Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbZGIMMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbZGIMMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 08:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756229AbZGIMM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 08:12:26 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:57079 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbZGIMMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 08:12:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RdRTAYhYnvE6HGrKDN38+IyFF8MhY25iQxVVkktzcYqZlvOClls6A4CvLUAzUjw738
         tt6XfBkLbuCFgbi97rqkxN5szG1lrctdC8WvXvaFvUxHD41P0fihEPLShsfraniPSUFX
         Ghfmae9/Vy/5F5JvzdggK64xhpQ/SmgyAr/wE=
MIME-Version: 1.0
In-Reply-To: <4A555DA7.6020009@oracle.com>
References: <20090623144221.GA29593@suse.de> <4A54A938.5030807@redhat.com>
	 <20090708145625.GA20690@suse.de> <4A54B5C2.9000908@redhat.com>
	 <20090708154758.GB20979@suse.de>
	 <21d7e9970907081423v6d3830eey227f3d54b10382a6@mail.gmail.com>
	 <b6a2187b0907081743w61102ff4u75d15c2f3cae26d@mail.gmail.com>
	 <4A554F1E.5020508@oracle.com>
	 <b6a2187b0907081931w7dcf2544m4b580f7841b80cf3@mail.gmail.com>
	 <4A555DA7.6020009@oracle.com>
Date: Thu, 9 Jul 2009 20:12:23 +0800
Message-ID: <b6a2187b0907090512y275c931ax7f93411ba5c97c28@mail.gmail.com>
Subject: Re: can we move USB_DEVICEFS to non-embedded?
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dave Airlie <airlied@gmail.com>, Greg KH <gregkh@suse.de>,
       Peter Jones <pjones@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Scott James Remnant <scott@canonical.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 11:01 AM, Randy Dunlap<randy.dunlap@oracle.com> wrote:
> arch/x86/Kconfig says:
>
> choice
>        depends on EXPERIMENTAL
>        prompt "Memory split" if EMBEDDED
>        default VMSPLIT_3G
>        depends on X86_32
>        ---help---
>          Select the desired split between kernel and user memory.
>
>          If the address range available to the kernel is less than the
>          physical memory installed, the remaining memory will be available
>          as "high memory". Accessing high memory is a little more costly
>          than low memory, as it needs to be mapped into the kernel first.
>          Note that increasing the kernel address space limits the range
>          available to user programs, making the address space there
>          tighter.  Selecting anything other than the default 3G/1G split
>          will also likely make your kernel incompatible with binary-only
>          kernel modules.

Got it. Thanks for the pointer.

Jeff.
