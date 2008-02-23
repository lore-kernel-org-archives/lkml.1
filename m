Return-Path: <linux-kernel-owner+w=401wt.eu-S934983AbYBWK1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934983AbYBWK1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:27:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbYBWK1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:27:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55873 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753460AbYBWK1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:27:40 -0500
Date: Sat, 23 Feb 2008 11:27:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       pzijlstr@redhat.com, arjan@infradead.org
Subject: Re: [PATCH] make c_idle.work have a static address.
Message-ID: <20080223102715.GL23833@elte.hu>
References: <1203692969-20788-1-git-send-email-gcosta@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203692969-20788-1-git-send-email-gcosta@redhat.com>
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


* Glauber Costa <gcosta@redhat.com> wrote:

> Currently, c_idle is declared in the stack, and thus, have no static 
> address.
> 
> Peter Zijlstra points out this simple solution, in which c_idle.work 
> is initializated separatedly. Note that the INIT_WORK macro has a 
> static declaration of a key inside.

thanks, applied.

	Ingo
