Return-Path: <linux-kernel-owner+w=401wt.eu-S933443AbYBVAUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443AbYBVAUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbYBVAUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:20:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:27018 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYBVAUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:20:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Mm429InhBGFSjRX8GSz09oRm1lIALrsiyTr9xvTLp5FWA1UlHcIKUvCP7D164EP/t659tHwxUwNV1GR0EWt5Uw5eNLmYn6BtRr83TiJ66RYFp4J6wm8o8T8uDLrBTsXQgqyrTuDZO2RDsTQwnKxfRkKoJ82mwmW2f4Aats4F7kY=
Message-ID: <b6a2187b0802211620q47f6601fuf7e88395d89b90c8@mail.gmail.com>
Date: Fri, 22 Feb 2008 08:20:30 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off aftersuspend-to-disk. Screen becomes green.
Cc: "Romano Giannetti" <romano@dea.icai.upcomillas.es>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "suspend-devel List" <suspend-devel@lists.sourceforge.net>,
       "Dave Airlie" <airlied@linux.ie>, "Greg KH" <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
In-Reply-To: <200802211302.27002.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com>
	 <b6a2187b0802201002t315548b5uac623759723842d0@mail.gmail.com>
	 <1203623002.3420.6.camel@localhost>
	 <200802211302.27002.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2008 at 5:02 AM, Jesse Barnes <jesse.barnes@intel.com> wrote:
> On Thursday, February 21, 2008 11:43 am Romano Giannetti wrote:
>  > > > Let's try to narrow it down to what the interaction is. Are you using
>  > > > something like acpi_sleep=s3_bios or similar?
>  > >
>  > > No. Not additional command line option except for resume=/dev/sda3
>  > > reboot=bios
>  >
>  > My laptop (a Toshiba satellite U305, intel 945GM chipset, used to need
>  > s2ram -f -p -m to STR correctly. In 2.6.25-rc2 I can simply STR with
>  > echo mem > /sys/power/state.
>
>  Cool, glad to hear at least one success report. :)

STR is always working on my X60s. No green screen, no hang. Both s2ram
and "echo mem > /sys/power/state". It's STD that's having problem.

But strange thing is I could even restore console after STD even
without agp and i915 module loaded, so I don't know how the console
vga got saved and restored.

Thanks,
Jeff.
