Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbYGGRvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbYGGRvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:51:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754177AbYGGRvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:51:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:36331 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbYGGRvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:51:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=SK4FQ0VlUBfxXsaxVixM0EQU9xrvJhNftH4KotECfRvlfvrGYf6joKU4dvnTkXBZ3f
         FEjUJ2vxNWtbYRJyBinkoR8Mhu62+Up2ZzMH+yh7bEzrHcSdHDgbJmr4I+4VwFCHbmZo
         pufBjnOZ3+UfKlY/SGXCC3Zze22hTvJZ8XpZQ=
Message-ID: <2c0942db0807071051v68bd2a28kc6617de7d414f06d@mail.gmail.com>
Date: Mon, 7 Jul 2008 10:51:37 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Ingo Molnar" <mingo@elte.hu>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>, "Len Brown" <lenb@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <Pine.LNX.4.55.0807071743280.20615@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
	 <20080707071706.GA3326@elte.hu>
	 <Pine.LNX.4.55.0807071224491.16767@cliff.in.clinika.pl>
	 <200807071428.53598.rjw@sisk.pl>
	 <Pine.LNX.4.55.0807071743280.20615@cliff.in.clinika.pl>
X-Google-Sender-Auth: df39bec3f77b5afe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 10:10 AM, Maciej W. Rozycki <macro@linux-mips.org> wrote:
>  Which means the workaround has not triggered and the rest of cosideration
> is therefore irrelevant.  Please get us these DMI IDs, so that we can see
> what's wrong with the quirk.

I have the nx6125 version of the laptop, though it's not long for this
world. Regardless, dmi data below. Earlier, I looked at your DMI match
strings up-thread and they seemed good, so you may be barking up the
wrong tree here.

ray@phoenix:~$ sudo grep . /sys/class/dmi/id/*
/sys/class/dmi/id/bios_date:03/10/2006
/sys/class/dmi/id/bios_vendor:Hewlett-Packard
/sys/class/dmi/id/bios_version:68DTT Ver. F.0E
/sys/class/dmi/id/board_name:308B
/sys/class/dmi/id/board_vendor:Hewlett-Packard
/sys/class/dmi/id/board_version:KBC Version 45.26
/sys/class/dmi/id/chassis_asset_tag:
/sys/class/dmi/id/chassis_serial:CND5500R4K
/sys/class/dmi/id/chassis_type:10
/sys/class/dmi/id/chassis_vendor:Hewlett-Packard
/sys/class/dmi/id/modalias:dmi:bvnHewlett-Packard:bvr68DTTVer.F.0E:bd03/10/2006:svnHewlett-Packard:pnHPCompaqnx6125(PZ880UA#ABA):pvrF.0E:rvnHewlett-Packard:rn308B:rvrKBCVersion45.26:cvnHewlett-Packard:ct10:cvr:
/sys/class/dmi/id/product_name:HP Compaq nx6125 (PZ880UA#ABA)
/sys/class/dmi/id/product_serial:CND5500R4K
/sys/class/dmi/id/product_uuid:4D0AF52B-ED6E-DA11-1880-66990A524D29
/sys/class/dmi/id/product_version:F.0E
/sys/class/dmi/id/sys_vendor:Hewlett-Packard
/sys/class/dmi/id/uevent:MODALIAS=dmi:bvnHewlett-Packard:bvr68DTTVer.F.0E:bd03/10/2006:svnHewlett-Packard:pnHPCompaqnx6125(PZ880UA#ABA):pvrF.0E:rvnHewlett-Packard:rn308B:rvrKBCVersion45.26:cvnHewlett-Packard:ct10:cvr:
