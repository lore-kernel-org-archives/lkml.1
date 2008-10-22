Return-Path: <linux-kernel-owner+w=401wt.eu-S1756245AbYJVO7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245AbYJVO7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYJVO7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:59:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:26283 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYJVO7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:59:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=P/G9Q0bSD1zBl7X200dqbttIM0LUGB+qNE0/Jz7ni7I575HjNHxExf3ya6VWBw8BuV
         JSFspp/p7iUAlIYrs35i9c20Hd1NWXceN1AkVam0fxON/HjZgKJkZnBT1tNauzl7aoVQ
         frwWGpJgqCEwcrOWqilW7JR2R9LGlqJbxtHqE=
Message-ID: <8bd0f97a0810220759h837794eo76c4413d6072dcf9@mail.gmail.com>
Date: Wed, 22 Oct 2008 10:59:20 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Bryan Wu" <cooloney@kernel.org>
Subject: Re: [BUG] re-modprobe a nand controller driver module will cause system crash.
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <386072610810212024l52cd86cen79061d7111c421ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <386072610810160356p3807f538la5087debe0c76866@mail.gmail.com>
	 <386072610810212024l52cd86cen79061d7111c421ba@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 23:24, Bryan Wu wrote:
> Did anyone meet this issue before?

actually i think we can see the same issue with the m25p80 driver ?
if i build it as a module and load/unload it, it crashes with same
name errors ...

root:/> rmmod m25p80
root:/> modprobe m25p80
m25p80 spi0.2: w25x10 (128 Kbytes)
Creating 3 MTD partitions on "m25p80":
0x00000000-0x00040000 : "bootloader(spi)"
mtd: partition "bootloader(spi)" extends beyond the end of device
"m25p80" -- size truncated to 0x20000
kobject_add_internal failed for 31:0 with -EEXIST, don't try to
register things with the same name in the same directory.
<crash message>
-mike
