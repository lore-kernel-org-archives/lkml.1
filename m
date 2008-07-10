Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbYGJRrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbYGJRrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755631AbYGJRrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:47:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33740 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079AbYGJRrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:47:36 -0400
Date: Thu, 10 Jul 2008 19:47:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH] remove duplicate call to use_tsc_delay.
Message-ID: <20080710174721.GA13012@elte.hu>
References: <1215709307-13558-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215709307-13558-1-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Glauber Costa <gcosta@redhat.com> wrote:

> Integration generated a duplicate call to use_tsc_delay. Particularly, 
> the one that is done before we check for general tsc usability seems 
> wrong.

applied to tip/x86/core - thanks Glauber.

	Ingo
