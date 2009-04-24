Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbZDXHRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbZDXHRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753432AbZDXHRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:17:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:19698 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbZDXHRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:17:31 -0400
Message-ID: <49F16786.7010401@petalogix.com>
Date: Fri, 24 Apr 2009 09:17:26 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-arch@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: Re: USE_ELF_CORE_DUMP?
References: <20090423183331.GA19899@lst.de>
In-Reply-To: <20090423183331.GA19899@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Currently all architectures but microblaze unconditionally define
> USE_ELF_CORE_DUMP.  The microblaze ommision seems like an error to
> me, so can we just kill this ifdef and make sure we are the same
> everywhere?
>   
Where did you find it?
I haven't seen in in mainline (noMMU kernel). It is in my MMU patches
which I want to send for review soon.

For noMMU I use CONFIG_BINFMT_FLAT (binfmt_flat.c) where I don't need
USE_ELF_CORE_DUMP
For MMU I use CONFIG_BINFMT_ELF (binfmt_elf.c) where USE_ELF_CORE_DUMP
make sense to me.

Can you give me some clue what you are trying to fix?

Thanks,
Michal


> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

