Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbXEKBuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbXEKBuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 21:50:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757741AbXEKBu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 21:50:28 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35334 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757343AbXEKBu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 21:50:28 -0400
Date: Thu, 10 May 2007 18:50:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Remi Colinet <remi.colinet@free.fr>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: Regression in 2.6.21-mm1 (git-input) on Dell D610 laptop
Message-Id: <20070510185021.c3d28048.akpm@linux-foundation.org>
In-Reply-To: <1178802325.46431895e9469@imp.free.fr>
References: <1178802325.46431895e9469@imp.free.fr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 15:05:25 +0200
Remi Colinet <remi.colinet@free.fr> wrote:

> My D610 ALPS Glide Point is unresponsive with 2.6.21-mm1 patch.
> No problem noticed with 2.6.21.
> 
> The culprit seems to be git-input. I have applied 2.6.21-mm1 on top of 2.6.21
> and then removed git-input patch. It is ok since then.
> 
> >From what i can see, no interrupt is raised from the GlidePoint with git-input
> applied. IRQ count 12 does not increase. It is when using the touchpad.
> 
>            CPU0
>   0:        160   IO-APIC-edge      timer
>   1:        935   IO-APIC-edge      i8042
>   7:          0   IO-APIC-edge      parport0
>   8:          1   IO-APIC-edge      rtc
>   9:          2   IO-APIC-fasteoi   acpi
> => 12:        114   IO-APIC-edge      i8042 <=
>  14:       3223   IO-APIC-edge      libata
>  15:          5   IO-APIC-edge      libata
>  16:          0   IO-APIC-fasteoi   uhci_hcd:usb1, ehci_hcd:usb5, Intel ICH6
>  17:          1   IO-APIC-fasteoi   uhci_hcd:usb2, ipw2200, Intel ICH6 Modem
>  18:          0   IO-APIC-fasteoi   uhci_hcd:usb3
>  19:          1   IO-APIC-fasteoi   uhci_hcd:usb4, yenta
> NMI:          0
> LOC:       4051
> ERR:          0
> MIS:          0
> 
> I have also tried to disable the ALPS driver in the .config file. IRQ 12 are
> then raised when using the Glide Point. X refuses to start.
> 

Are you able to test 2.6.21-mm2?

Thanks.
