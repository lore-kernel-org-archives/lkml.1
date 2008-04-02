Return-Path: <linux-kernel-owner+w=401wt.eu-S1759049AbYDBRkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759049AbYDBRkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbYDBRjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:39:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53933 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795AbYDBRjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:39:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Justin Mattock" <justinmattock@gmail.com>
Subject: Re: suspend
Date: Wed, 2 Apr 2008 19:39:45 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Alan <alan@lxorguk.ukuu.org.uk>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Pavel Machek <pavel@ucw.cz>
References: <dd18b0c30804012331oc548416k113e492d7dc9c189@mail.gmail.com> <200804021419.06672.rjw@sisk.pl> <dd18b0c30804020853w50e0290cy8b0303e30f2bcfec@mail.gmail.com>
In-Reply-To: <dd18b0c30804020853w50e0290cy8b0303e30f2bcfec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804021939.46733.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 of April 2008, Justin Mattock wrote:
> Hello; the only problems I see after a suspend is the appletouch
> looses its scroll function,

Is that a USB device or some other kind?

> as well as the bluetooth mighty mouse(probably dont have my xorg.conf set up
> for suspend), 

That might be related to the issue that Pavel is fighting with.

> wpa_supplicant seems to not respond as well.

What wireless adapter is there in your box?

> also here is what I see with sata:    ( revalidation failed?)

Let's Cc the SATA people.

> [ 1233.811794] sd 2:0:1:0: [sda] Starting disk
> [ 1234.013599] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
> [ 1234.013601] ata1.00: ACPI cmd ef/03:44:00:00:00:a0 filtered out
> [ 1234.180232] ata1.00: configured for UDMA/66
> [ 1222.732011] ata3.01: NODEV after polling detection
> [ 1222.732016] ata3.01: revalidation failed (errno=-2)
> [ 1222.732020] ata3: failed to recover some devices, retrying in 5 secs
> [ 1227.908752] ata3.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
> [ 1227.908758] ata3.01: ACPI cmd ef/03:45:00:00:00:b0 filtered out
> [ 1227.922377] ata3.01: configured for UDMA/100
> [ 1227.945525] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> [ 1227.945525] sd 2:0:1:0: [sda] Write Protect is off
> [ 1227.945525] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
> [ 1227.945525] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [ 1227.945525] applesmc: device has already been initialized (0xe0, 0x00).
> 
> Other than that it seems to work alright.

OK

Thanks,
Rafael
