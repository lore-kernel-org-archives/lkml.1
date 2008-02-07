Return-Path: <linux-kernel-owner+w=401wt.eu-S932336AbYBGMx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbYBGMx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYBGMxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:53:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42911 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbYBGMxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:53:45 -0500
Date: Thu, 7 Feb 2008 13:53:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Paalanen <pq@iki.fi>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/4] x86 mmiotrace: move files into arch/x86/mm/
Message-ID: <20080207125327.GB27234@elte.hu>
References: <1201660102.8837.9.camel@brick> <1201660453.8837.13.camel@brick> <20080130200827.322c4f7d@daedalus.pq.iki.fi> <20080131150746.GB11996@elte.hu> <20080131180253.6c007852@daedalus.pq.iki.fi> <20080131081507.5edcde10@laptopd505.fenrus.org> <20080203085522.2b63e15b@daedalus.pq.iki.fi> <20080203070321.GA8293@elte.hu> <20080205222807.7b35ef2b@daedalus.pq.iki.fi> <20080205223958.2cab8ce3@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205223958.2cab8ce3@daedalus.pq.iki.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2107]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Pekka,

i've picked up your latest cleanups, but a fundamental worry still 
remains: all the ugly 'custom pagefault handlers' stuff. Lets just have 
one clean direct callback to mmiotrace, ok?

	Ingo
