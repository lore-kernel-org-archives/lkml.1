Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbYFCQSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbYFCQSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbYFCQRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:17:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:34766 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbYFCQRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:17:41 -0400
Message-ID: <48456EA3.6030909@suse.de>
Date: Tue, 03 Jun 2008 18:17:39 +0200
From: Stefan Assmann <sassmann@suse.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jon Masters <jcm@redhat.com>
Cc: Olaf Dabrunz <od@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Boot IRQ quirks and rerouting
References: <12124107071847-git-send-email-od@suse.de> <1212508321.22357.13.camel@londonpacket.bos.redhat.com>
In-Reply-To: <1212508321.22357.13.camel@londonpacket.bos.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Masters schrieb:
> I like the patch series, insomuch as the intention is good, and it does
> away with the special PCI IRQ quirk patches some of us are carrying in
> our vendor trees to temporarily workaround this problem[0]. Also, I'm
> extremely impressed with the research that went into this, since I
> repeatedly tried to get ahold of information about disabling this
> unfortunate "feature" of various bridges, without much success.
>   
In a perfect world these "features" as you call them should be disabled 
by the bios, but this is not happening everywhere. Some bioses seem to 
have code for that in ACPI others rely on the OS to do the work.
> However, I really am not happy with the implementation as it stands. The
> duplicated table of quirks that doesn't really fit in with the existing
> PCI quirks infrastructure, the weird naming of the kernel options, and
> various other things that Thomas has already mentioned in his reply.
> Therefore, I think this needs a bit more reworking before going in.
>   
We're already working on that thanks to Thomas' review and will send an 
updated patchset asap. If there's anything you'd like to have changed 
feel free to let us know.
> Thanks!
>
> Jon.
>
> [0] The real fix come when we move IRQ handling in RT to per-device
> threads, as is the longer term intention. Then you can quiesse the
> device immediately and not the mask/unmask cycle that fails here.
>
>
>   

Thanks :)
    Stefan

-- 
Stefan Assmann          | SUSE LINUX Products GmbH
Software Engineer       | Maxfeldstr. 5, D-90409 Nuernberg
Mail : sassmann@suse.de | GF: Markus Rex, HRB 16746 (AG Nuernberg)

