Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbZJPIXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbZJPIXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZJPIX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:23:29 -0400
Received: from lucidpixels.com ([75.144.35.66]:51417 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbZJPIX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:23:28 -0400
Date: Fri, 16 Oct 2009 04:22:51 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Bryan Donlan <bdonlan@gmail.com>
cc: bruce.w.allan@intel.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] Add quirk for ACPI reboots on Intel DP55KG boards.
In-Reply-To: <3e8340490910151749r583d46c0o212e1f4ff7eac955@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0910160421390.2841@p34.internal.lan>
References: <alpine.DEB.2.00.0910151655590.4808@p34.internal.lan>  <1255645796-29944-1-git-send-email-bdonlan@gmail.com> <alpine.DEB.2.00.0910151831020.15317@p34.internal.lan>  <alpine.DEB.2.00.0910151852510.8329@p34.internal.lan>
 <alpine.DEB.2.00.0910151855320.3244@p34.internal.lan>  <3e8340490910151605j357b303btb26505a2c04cf2d4@mail.gmail.com>  <alpine.DEB.2.00.0910151911490.10951@p34.internal.lan> <3e8340490910151749r583d46c0o212e1f4ff7eac955@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Oct 2009, Bryan Donlan wrote:

> On Thu, Oct 15, 2009 at 7:30 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>> Same, all methods fail, :(
>>
>> Justin.
>
> Was there a message on dmesg about setting the reboot type?
> dmesg | grep 'series board detected'
>
> If not, please dump the DMI identification values Linux is using like so:
> for i in /sys/class/dmi/id/*; do if [ -f $i ]; then echo -n "$i \"";
> cat $i | tr -d '\n'; echo '"'; fi; done
>
Here you go:

# for i in /sys/class/dmi/id/*; do if [ -f $i ]; then echo -n "$i \"";  cat $i | tr -d '\n'; echo '"'; fi; done
/sys/class/dmi/id/bios_date "09/28/2009"
/sys/class/dmi/id/bios_vendor "Intel Corp."
/sys/class/dmi/id/bios_version "KGIBX10J.86A.3822.2009.0928.1349"
/sys/class/dmi/id/board_asset_tag "Base Board Asset Tag"
/sys/class/dmi/id/board_name "DP55KG"
/sys/class/dmi/id/board_serial "XXXXXXXXXXXX"
/sys/class/dmi/id/board_vendor "Intel Corporation"
/sys/class/dmi/id/board_version "AAE47218-403"
/sys/class/dmi/id/chassis_asset_tag "        "
/sys/class/dmi/id/chassis_serial "        "
/sys/class/dmi/id/chassis_type "2"
/sys/class/dmi/id/chassis_vendor "        "
/sys/class/dmi/id/chassis_version "        "
/sys/class/dmi/id/modalias "dmi:bvnIntelCorp.:bvrKGIBX10J.86A.3822.2009.0928.1349:bd09/28/2009:svn:pn:pvr:rvnIntelCorporation:rnDP55KG:rvrAAE47218-403:cvn:ct2:cvr:"
/sys/class/dmi/id/product_name "        "
/sys/class/dmi/id/product_serial "        "
/sys/class/dmi/id/product_uuid "81BCB172-8BB9-11DE-B5DA-001CC0C81E6F"
/sys/class/dmi/id/product_version "        "
/sys/class/dmi/id/sys_vendor "        "
/sys/class/dmi/id/uevent "MODALIAS=dmi:bvnIntelCorp.:bvrKGIBX10J.86A.3822.2009.0928.1349:bd09/28/2009:svn:pn:pvr:rvnIntelCorporation:rnDP55KG:rvrAAE47218-403:cvn:ct2:cvr:"

Justin.

