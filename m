Return-Path: <linux-kernel-owner+w=401wt.eu-S1759163AbYBMMbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759163AbYBMMbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYBMMbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:31:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48742 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbYBMMbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:31:39 -0500
Date: Wed, 13 Feb 2008 13:31:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jody Belka <lists-lkml@pimb.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Miguel Boton <mboton@gmail.com>
Subject: Re: [PATCH] x86: fixup machine_ops reboot_{32|64}.c unification
	fallout
Message-ID: <20080213123126.GB5722@elte.hu>
References: <20080212233748.GX7980@pimb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212233748.GX7980@pimb.org>
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


* Jody Belka <lists-lkml@pimb.org> wrote:

> Please cc on any replies, thanks.
> ---
> When reboot_32.c and reboot_64.c were unified (commit 4d022e35fd...),
> the machine_ops code was broken, leading to xen pvops kernels failing
> to properly halt/poweroff/reboot etc. This fixes that up.

thanks Jody, applied.

	Ingo
