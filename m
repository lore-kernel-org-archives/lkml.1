Return-Path: <linux-kernel-owner+w=401wt.eu-S1758235AbZFVPne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235AbZFVPne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756781AbZFVPnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:43:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41144 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963AbZFVPnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:43:20 -0400
Date: Mon, 22 Jun 2009 16:43:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sudeep K N <sudeepholla.maillist@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, drzeus-mmc@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: Rootfs in eMMC: Kernel panic ...Attempted to kill init!
Message-ID: <20090622154308.GC29188@n2100.arm.linux.org.uk>
References: <366f00c80906180218p539f9df9md30f629787fabeb2@mail.gmail.com> <20090619134446.GI24573@n2100.arm.linux.org.uk> <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <366f00c80906220713o7ad61a8elb6b278b7313107d8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 22, 2009 at 07:43:40PM +0530, Sudeep K N wrote:
> Hi Russell,
> 
> Thanks for the suggestion.
> With the logs it is clear that crash is in the userspace.
> I am getting one of the 2 logs(below) randomly.
> >From trial#2,
> pgd = c60bc000
> [00000000] *pgd=061ee031, *pte=00000000, *ppte=00000000
> I could understand that the page tables are not proper.
> I am not able understand how to proceed.
> 
> Trial#1:
> VFS: Mounted root (ext2 filesystem).
> Freeing init memory: 108K
> linuxrc (1): undefined instruction: pc=40008100
> Code: e08e3003 eb002842 e2801008 e58c217c (e0812103)

Your processor is misbehaving; none of the above hex codes are undefined
instructions, so you shouldn't be taking an undefined instruction trap.

That, coupled with the random nature of these crashes leads me to believe
that it's a case of noisy power supply to the SoC.  Suggest you get your
hardware people to check your board.
