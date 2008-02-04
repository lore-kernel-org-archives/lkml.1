Return-Path: <linux-kernel-owner+w=401wt.eu-S1755564AbYBDOss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbYBDOss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYBDOsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:48:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37236 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbYBDOsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:48:40 -0500
Date: Mon, 4 Feb 2008 15:48:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       petr@vandrovec.name
Subject: Re: Commit f06e4ec breaks vmware
Message-ID: <20080204144824.GA13154@elte.hu>
References: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr> <20080204115144.GA17850@elte.hu> <b6a2187b0802040601s76222435t306aef2059cbbb2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0802040601s76222435t306aef2059cbbb2b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0008]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

> On Feb 4, 2008 7:51 PM, Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > sad to say, but f06e4ec... breaks booting the kernel in vmware
> > > commit f06e4ec1c15691b0cfd2397ae32214fa36c90d71
> 
> I had the same problem. But I bisect down to a earlier commit.
> Reverting this patch, and I can boot up using vmware.
> 
> commit 8d947344c47a40626730bb80d136d8daac9f2060
> Author: Glauber de Oliveira Costa <gcosta@redhat.com>
> Date:   Wed Jan 30 13:31:12 2008 +0100
> 
>     x86: change write_idt_entry signature

32-bit or 64-bit guest kernel?

	Ingo
