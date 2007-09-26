Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbXIZHv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbXIZHv1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 03:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbXIZHvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 03:51:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:21183 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXIZHvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 03:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=mQspTDhcy7+RL/UZGilODXDJM0MLIh53JcVwCjGOzIL+UQw9JHfjGVktUZOsf+XBQwdNygQdf0j7CjqgepvdcIKHXYYgeQtRvNYTq8F/r61O18nYWgZpfjDLS3HfUs9oDI/KcAC1fxJgs/24rTk5ZMEaVkM4rWLjSoemXPcrAEk=
Message-ID: <46FA0F71.3040800@gmail.com>
Date: Wed, 26 Sep 2007 09:51:13 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Dave Airlie <airlied@gmail.com>
Subject: black screen after kill X [Was: 2.6.23-rc8-mm1]
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
In-Reply-To: <20070925014625.3cd5f896.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2007 10:46 AM, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm1/

I don't know if this is a regression, I hadn't suspend working before rc7-mm1
(rc7-mm1 is the same), but
X -> kill X -> console (OK)
X -> suspend (2ram) -> resume -> kill X -> black screen (no signal), reboot
stucks at some point after some services are shutted down

X driver: intel (compiled from git)
agp dmesg part:
Linux agpgart interface v0.102
agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)

Is this what should I try?

agpgart: Detected an Intel G33 Chipset.
agpgart: Detected 8192K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[drm] Initialized i915 1.6.0 20060119 on minor 0

thanks,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
