Return-Path: <linux-kernel-owner+w=401wt.eu-S1753396AbZI3J6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbZI3J6q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 05:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZI3J6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 05:58:45 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:33493 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZI3J6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 05:58:45 -0400
From: Berthold Gunreben <b.gunreben@web.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
Date: Wed, 30 Sep 2009 11:58:43 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Niel Lambrechts <niel.lambrechts@gmail.com>
References: <clqON-2Xv-7@gated-at.bofh.it> <200909182226.39660.b.gunreben@web.de> <4ABC42F9.3010403@gmail.com>
In-Reply-To: <4ABC42F9.3010403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909301158.43972.b.gunreben@web.de>
X-Provags-ID: V01U2FsdGVkX18k9qKLZ6MVD3n9AGHiOdKpqU8+y2gTN13VW2D8
	p8kUTdpYTVzLZ3PUbj10wKiLv4bk4WkrBX7XkR0oDVXr1KJOZL
	w/I+ojfos=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

thanks a lot for your reply.

Am Freitag 25 September 2009 schrieb Tejun Heo:
> Hello, Berthold.
>
> The disk is most likely losing power briefly.  After boot, run
> "smartctl -a" on the device and record the output.  After triggering
> the problem, do it again.  See if Start_Stop_Count, Power_Cycle_Count
> or Power-Off_Retract_Count has increased.  If so, take out your PSU,
> bury it half-deep in your backyard, apply some gasoline, light it up
> and enjoy the sight of perishing evil with a can of beer.

You might be right. However, I cannot reproduce the problem anymore, since I 
switched to the totally unsupported JFS as filesystem.

In the meantime, I was able to copy 1.5TB of data back to the array, and the 
system also survived artificially generated high load. If the problem is a 
race (which I do not know), it might still be there. Obviously, it does not 
show up as often again.

It could still be the power supply of course, but I don't understand why a new 
kernel would trigger power outages so often (current kernels triggered the 
problem latest after 5 minutes). Maybe it has something to do with the 
chipset (ICH7R) which is capable of hot remove/add disks. Or it is related to 
the hotswap harddisk slots in the case 
(http://www.chenbro.eu/corporatesite/products_detail.php?sku=79 ). I have no 
idea....

Thanks

Berthold

