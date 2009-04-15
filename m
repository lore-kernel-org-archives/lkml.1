Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZDOAlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZDOAlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZDOAlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:41:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:10260 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZDOAle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fF63RDH7DBr2w3jnwpFOMqXOCwmPjgqqqTCHM/9ahUE6swKRu41vsv5NHu1ofyBOS+
         3YFFI7UzLnJFz+naQv1IoRWcN/i37Zh2N4IWQ+vQRmwgcgC/9lvjlg8dwhIO9U/PFqXT
         nV9YXdm7tI0dS6TKYcvzOpG6bJhRnPrbeNtc8=
Subject: Re: 2.6.30-rc1 (latest git): thinkpad-acpi: cannot control
 brightness with hotkeys (BISECTED)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, mjg59@srcf.ucam.org,
       yakui_zhao <yakui.zhao@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <49E5234E.5070303@gmail.com>
References: <49E10684.5090101@gmail.com>
	 <20090411150555.8b13ed18.akpm@linux-foundation.org>
	 <20090412161448.GC26502@khazad-dum.debian.net> <49E234ED.5010105@gmail.com>
	 <1239585695.5564.5.camel@localhost.localdomain> <49E3575A.60204@gmail.com>
	 <20090413203450.GC16152@khazad-dum.debian.net> <49E5234E.5070303@gmail.com>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 03:41:28 +0300
Message-Id: <1239756088.8954.5.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-15 at 01:59 +0200, Niel Lambrechts wrote:
> On 04/13/2009 10:34 PM, Henrique de Moraes Holschuh wrote:
> > On Mon, 13 Apr 2009, Niel Lambrechts wrote:
> >   
> >>>> In 2.6.29.1:
> >>>> lrwxrwxrwx 1 root root 0 Apr 12 20:01 /sys/class/backlight/acpi_video0
> >>>> -> ../../devices/virtual/backlight/acpi_video0
> >>>>         
> >
> > Well, that at least confirms that thinkpad-acpi doesn't have anything to
> > do with your troubles, you were using acpi video.
> >   
> 
> Okay, I've bisected it to:
> 
> 74a365b3f354fafc537efa5867deb7a9fadbfe27 is first bad commit
> commit 74a365b3f354fafc537efa5867deb7a9fadbfe27
> Author: Matthew Garrett <mjg59@srcf.ucam.org>
> Date:   Thu Mar 19 21:35:39 2009 +0000
> 
>     ACPI: Populate DIDL before registering ACPI video device on Intel
> 
> ---
> 
> Matthew, can you help?
> 
> Regards,
> Niel


Just to note,

I have nvidia, and yet have the same bug.
I reverted this commit - didn't help.

I get lots of 
ACPI: Failed to switch the brightnes
when I press hardware keys that change brightness
(even these sometimes don't work)


the /sys/class/backlight is empty

2.6.29 works fine.


Best regards,
	Maxim Levitsky

