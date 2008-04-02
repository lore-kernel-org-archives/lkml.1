Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYDBPxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYDBPxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbYDBPxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:53:42 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:34679 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225AbYDBPxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:53:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KiX/Sfr3t3C2NS2vb9ek3bgPegSBXXDfAXI4HUNGNzvg6BwzxJyt2IAVFGOndPPXLtd+Z8AUbuq1UrDRYMTd1XUlA9NIhn2cfy9JOjq/hEcwlJ/2ZrcJo0nHKt3Mhd8iixZnj5J1XfUcrZmZ6iX+wtg96ty+ZEmC3XOGZabNftE=
Message-ID: <dd18b0c30804020853w50e0290cy8b0303e30f2bcfec@mail.gmail.com>
Date: Wed, 2 Apr 2008 15:53:40 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200804021419.06672.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com>
	 <200804021419.06672.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; the only problems I see after a suspend is the appletouch
looses its scroll function, as well as the bluetooth mighty
mouse(probably dont have my xorg.conf set up for suspend),
wpa_supplicant seems to not respond as well.
also here is what I see with sata:    ( revalidation failed?)

[ 1233.811794] sd 2:0:1:0: [sda] Starting disk
[ 1234.013599] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[ 1234.013601] ata1.00: ACPI cmd ef/03:44:00:00:00:a0 filtered out
[ 1234.180232] ata1.00: configured for UDMA/66
[ 1222.732011] ata3.01: NODEV after polling detection
[ 1222.732016] ata3.01: revalidation failed (errno=-2)
[ 1222.732020] ata3: failed to recover some devices, retrying in 5 secs
[ 1227.908752] ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
[ 1227.908758] ata3.01: ACPI cmd ef/03:45:00:00:00:b0 filtered out
[ 1227.922377] ata3.01: configured for UDMA/100
[ 1227.945525] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[ 1227.945525] sd 2:0:1:0: [sda] Write Protect is off
[ 1227.945525] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[ 1227.945525] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[ 1227.945525] applesmc: device has already been initialized (0xe0, 0x00).

Other than that it seems to work alright.
regards;

            Justin P. Mattock

On Wed, Apr 2, 2008 at 12:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> On Wednesday, 2 of April 2008, Justin Mattock wrote:
>  > Hello; attached is my results with testing 2.6.25-rc8 with echo mem >
>  > /sys/power/state
>  > hopefully this helps in debugging the issues with the imac.
>  > I'm running a macbook pro 15' with the ATI chipset.
>  > regards;
>
>  Well, I don't see anything particularly wrong in the log you sent.
>
>  Wnat exactly is wrong with the box after a resume?
>
>  Rafael
>



-- 
Justin P. Mattock
