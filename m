Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZLECMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZLECMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 21:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbZLECMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 21:12:50 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44029 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbZLECMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 21:12:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u5Sk+QgA5ZK+Zc9EUOVTDUD/vU8WgcDuYqZ2X1ltOXa+aiz+DsIbTW+wkGhssI3cv8
         FEu54A/gkoSpiSGlcOunQmOIEiPuYIk2KSjkMID4azmpkAd47CsPJ9nqeyFKMJi3t8NR
         6T39lKxR2EZXBCvKFLhzB91a10lkX7S0rfrdk=
MIME-Version: 1.0
In-Reply-To: <173abc14-0cbc-4340-b21f-3e8bc15f02dd@default>
References: <173abc14-0cbc-4340-b21f-3e8bc15f02dd@default>
Date: Sat, 5 Dec 2009 03:12:54 +0100
Message-ID: <c5bd819b0912041812g394aa26eia1b839e1f0c3c98d@mail.gmail.com>
Subject: Re: Can't compile 2.6.32
From: Grozdan <neutrino8@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 5, 2009 at 3:03 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
> A bit more info on this. It seems there's a
> CONFIG_ACPI_CUSTOM_OVERRIDE_INITRAMFS in the "normal" SUSE source RPM
> package (which in my config is not enabled, but there is an option for
> that) and looking at the drivers/acpi/osl.c and the
> include/acpi/acpiosxf.h file, there's a define for this in the header
> which has acpi_load_override_tables(void); and also this is present in
> the osl.c file.... see both attachments. I could not find the same
> thing in the kernel-default-vanilla source RPM package also present in
> the repo.
>
> ~~~~~~~~~~~~~~~~~~  reply: ~~~~~~~~~~~~~~~~~~~~~~~~
>
> You should take this up with the OpenSUSE people, not lkml.

Yeah I know, and what I've been planning to. But, I enabled this
option some minutes ago and tried to compile again. It passed
compilation of osl.c so I think it's all good now. There have been
quite a lot of complains about how SUSE configures and splits its
kernel packages; for the new 11.2 release, I've read a lot of them on
the SUSE forum where people couldn't even boot if the kernel-desktop
was selected and installed but had no problems with the
kernel-default. I don't know who configures these kernels (I don't use
SUSE configured/compiled kernels, only grab them from the build
service & configure/compile them myself) but it seems it's getting
progressively worse, not to mention in how many different packages
they've split the kernel and people are getting confused about this :(

Anyways, thanks so far ;)

>
> Thanks,
> ~Randy
>
