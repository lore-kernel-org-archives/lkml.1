Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbYDBTTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbYDBTTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754683AbYDBTTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:19:06 -0400
Received: from hs-out-0708.google.com ([64.233.178.248]:37513 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYDBTTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L8R60NUR52T1D2X4PTO/CU8lST5w112/T04tk6NNafzipYT2DX+ur51GojAXVWcumHyRs7nWjl08HvtgI6uxVa554g/zCn0d2vLkDOJ9xldmH7fG1DQQw/vOBPX5I+txgGSAOKVToyc1fe7aRWSdvWHYaojmm68CaJ03BlVzb9E=
Message-ID: <dd18b0c30804021218t700484faua57a46e237ea581f@mail.gmail.com>
Date: Wed, 2 Apr 2008 19:18:57 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: suspend
Cc: linux-kernel@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>
In-Reply-To: <200804021939.46733.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com>
	 <200804021419.06672.rjw@sisk.pl>
	 <dd18b0c30804020853w50e0290cy8b0303e30f2bcfec@mail.gmail.com>
	 <200804021939.46733.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello; I did some testing with the suspend and it seems the mighty
mouse is being claimed by something before bluetooth daemon can claim
it. the infrared device gives me no response even after issuing
killall lirc and lircd and restarting the daemons,
I'm able to get uvcvideo working after a rrmod uvcvideo then a
modprobe uvcvideo then I'm able to use gmplayer tv:// -vf mirror to
view the camera. with appletouch i have to ctrl,alt,del then rmmod
appletouch then modprobe and startx for the scroll function to work
again.

with sata = ata3.01: revalidation failed (errno=-2) I suspended
simultaneously, on the third time this seems to show up.

Ill send the dmesg from the three suspends as soon as I locate the
e-mail address to  the Sata people.

As for wpa_supplicant I haven't tested that yet as well as other
devices that might not be functioning properly.
regards;

             Justin P. Mattock


On Wed, Apr 2, 2008 at 5:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, 2 of April 2008, Justin Mattock wrote:
>  > Hello; the only problems I see after a suspend is the appletouch
>  > looses its scroll function,
>
>  Is that a USB device or some other kind?
>
>  > as well as the bluetooth mighty mouse(probably dont have my xorg.conf set up
>  > for suspend),
>
>  That might be related to the issue that Pavel is fighting with.
>
>  > wpa_supplicant seems to not respond as well.
>
>  What wireless adapter is there in your box?
>
>  > also here is what I see with sata:    ( revalidation failed?)
>
>  Let's Cc the SATA people.
>
>  > [ 1233.811794] sd 2:0:1:0: [sda] Starting disk
>  > [ 1234.013599] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
>  > [ 1234.013601] ata1.00: ACPI cmd ef/03:44:00:00:00:a0 filtered out
>  > [ 1234.180232] ata1.00: configured for UDMA/66
>  > [ 1222.732011] ata3.01: NODEV after polling detection
>  > [ 1222.732016] ata3.01: revalidation failed (errno=-2)
>  > [ 1222.732020] ata3: failed to recover some devices, retrying in 5 secs
>  > [ 1227.908752] ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
>  > [ 1227.908758] ata3.01: ACPI cmd ef/03:45:00:00:00:b0 filtered out
>  > [ 1227.922377] ata3.01: configured for UDMA/100
>  > [ 1227.945525] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
>  > [ 1227.945525] sd 2:0:1:0: [sda] Write Protect is off
>  > [ 1227.945525] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
>  > [ 1227.945525] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
>  > enabled, doesn't support DPO or FUA
>  > [ 1227.945525] applesmc: device has already been initialized (0xe0, 0x00).
>  >
>  > Other than that it seems to work alright.
>
>  OK
>
>  Thanks,
>  Rafael
>



-- 
Justin P. Mattock
