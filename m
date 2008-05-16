Return-Path: <linux-kernel-owner+w=401wt.eu-S1756317AbYEPLw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317AbYEPLw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 07:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYEPLwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 07:52:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44403 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbYEPLwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 07:52:20 -0400
Date: Fri, 16 May 2008 13:52:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] scheduler: reorder task_struct to reduce padding on
	64bit builds
Message-ID: <20080516115208.GE6444@elte.hu>
References: <1210849755.3274.11.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210849755.3274.11.camel@castor.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Richard Kennedy <richard@rsk.demon.co.uk> wrote:

> This patch removes 24 bytes of padding and allows 1 extra object per 
> slab on my fedora based config. Patch against 2.6.26-rc2 & running 
> successfully on my AMD 64 desktop machine.

applied, thanks. Nice patch - task_struct hasnt been field-ordering 
optimized for quite some time.

	Ingo
