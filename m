Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbYAOJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbYAOJAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:00:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYAOJAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:00:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38808 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbYAOJAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:00:23 -0500
Date: Tue, 15 Jan 2008 10:00:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: sam@ravnborg.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix 32bit build for git-x86
Message-ID: <20080115090011.GA18963@elte.hu>
References: <20080115010449.GA5521@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080115010449.GA5521@basil.nowhere.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> Fixes the 32build here with git-x86 (tip 
> 2f42671697ea9abc7d10ea7f663d6ef6e8ec6358)
> 
> Fix git-x86 build

your patch does not apply and this build bug is not present in x86.git. 
This bit:

> -		    KBUILD_IMAGE := $(boot)/bzImage
> +KBUILD_IMAGE := $(boot)/bzImage

that whitespaec is tabs in your repository while it's spaces in mine and 
in the x86.git repository as well. So there's no bug in x86.git AFAICS.

	Ingo
