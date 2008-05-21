Return-Path: <linux-kernel-owner+w=401wt.eu-S1764718AbYEUJJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764718AbYEUJJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbYEUJJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:09:46 -0400
Received: from gw.goop.org ([64.81.55.164]:56426 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765AbYEUJJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:09:45 -0400
Message-ID: <4833E6BA.3060408@goop.org>
Date: Wed, 21 May 2008 10:09:14 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Markus Armbruster <armbru@redhat.com>
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, linux-fbdev-devel@lists.sourceforge.net,
       adaplas@gmail.com, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com, mingo@redhat.com, akpm@linux-foundation.org,
       Pat Campbell <plc@novell.com>
Subject: Re: [PATCH 0/5] xen pvfb: Para-virtual framebuffer, keyboard and
 pointer driver updates
References: <87d4ngm4s4.fsf@pike.pond.sub.org>
In-Reply-To: <87d4ngm4s4.fsf@pike.pond.sub.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus Armbruster wrote:
> This is an update to the Linux part of the Xen PVFB.  Linux Xen PVFB
> is a pair of Xen para-virtual frontend device drivers:
> drivers/video/xen-fbfront.c provides a framebuffer, and
> drivers/input/xen-kbdfront provides keyboard and mouse.  Their
> backends run in dom0 user space.
>
> Parts in this patch series:
>
> 1. Enable Xen console by default in domU
> 2. Pointer z-axis (mouse wheel) support
> 3. Module aliases to support module autoloading
> 4. Zero unused bytes in events sent to backend
> 5. Dynamic mode support (screen resizing)
>
> To the best of my knowledge, these patches are independent.  The last
> one needs a bit of trivial merging to apply without the first one.  I
> tested only 1, 1+2, 1+2+3, 1+2+3+4, and the complete series.  I'm
> happy to split this into different parts if that helps.
>   

Thanks Markus,

This looks good.  I'll stick it into my queue and feed it via Ingo when 
I've given it a bit of a test.

Are we happy that the preferred console stuff is now the best solution?  
Does it solve your installer issues?

    J
