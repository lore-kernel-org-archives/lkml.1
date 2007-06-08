Return-Path: <linux-kernel-owner+w=401wt.eu-S968986AbXFHPQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968986AbXFHPQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968365AbXFHPQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:16:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:18414 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968280AbXFHPQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:16:33 -0400
Date: Fri, 8 Jun 2007 17:16:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Adrian Bunk <bunk@stusta.de>
cc: Jesper Juhl <jesper.juhl@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jcm@jonmasters.org, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
In-Reply-To: <20070608144230.GA5500@stusta.de>
Message-ID: <Pine.LNX.4.64.0706081710380.10769@fbirervta.pbzchgretzou.qr>
References: <9a8748490706060205y1fc8e354p4af7426fd76dd816@mail.gmail.com>
 <Pine.LNX.4.64.0706071622280.8762@fbirervta.pbzchgretzou.qr>
 <20070607193413.GR5500@stusta.de> <20070607232248.332edee8@the-village.bc.nu>
 <20070607232152.GU5500@stusta.de> <20070608004117.57868755@the-village.bc.nu>
 <20070608000455.GW5500@stusta.de> <20070608115219.694c642d@the-village.bc.nu>
 <20070608123942.GZ5500@stusta.de> <9a8748490706080734h6ce5959fq6e7cb802d9a555cc@mail.gmail.com>
 <20070608144230.GA5500@stusta.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-699020219-538899979-1181315791=:10769"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---699020219-538899979-1181315791=:10769
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


On Jun 8 2007 16:42, Adrian Bunk wrote:
>On Fri, Jun 08, 2007 at 04:34:01PM +0200, Jesper Juhl wrote:
>> On 08/06/07, Adrian Bunk <bunk@stusta.de> wrote:
>> [snip]
>>>
>>> It's not only about MODULE_AUTHOR, if you consider it rude to limit
>>> people's names to ASCII, then don't forget that we have printk's like
>>>     Linux agpgart interface v0.102 (c) Dave Jones
>>>
>>> What happens if the maintainer changes and it's now
>>>      Linux agpgart interface v0.103 (c) Dave Ønes
>>>
>>> Does the console handle it correctly during boot?
>>> Can all tools that process the syslog cope with it?
>>>
>>> Perhaps the answer is in both cases "yes", but it's a completely
>>> untested area.
>>>
>>> We really must have all bugs shaken out and all users using fixed tools
>>> _before_ we can start outputting UTF-8 - limiting people's names to
>>> ASCII in not ideal, but IMHO causing breakages for users is a much
>>> bigger problem.
>>
>> I haven't looked at it in depth yet, but it would seem we already have
>> a few files that need to be looked at with this in mind.  Looks like
>> it's not exactely a new problem (although all the following could be
>> in comments of course)...
>>...
>
>They should all be in comments, and all UTF-8 I've ever seen in such 
>files was only in comments (mostly author names). So yes, adding UTF-8 
>to program code will result in new problems.
>
>If you find any source file that contains UTF-8 outside of comments 
>please complain loudly.

I present loudly and proudly (I *don't* complain):

17:11 ichi:/ws/linux-2.6.22-rc4 > find . -iname '*.[ch]' -print0 | xargs -0 grep MODULE_AUTHOR | grep -P '[\x80-\xff]' --color=never
./arch/i386/kernel/cpu/cpufreq/e_powersaver.c:MODULE_AUTHOR("Rafa� Bilski <rafalbilski@interia.pl>");
./drivers/char/watchdog/i6300esb.c:MODULE_AUTHOR("Ross Biro and David H�deman");
./drivers/char/watchdog/w83627hf_wdt.c:MODULE_AUTHOR("P�raig Brady <P@draigBrady.com>");
./drivers/hwmon/via686a.c:MODULE_AUTHOR("Ky�ti M�kki <kmalkki@cc.hut.fi>, "
./drivers/i2c/busses/i2c-via.c:MODULE_AUTHOR("Ky�ti M�kki <kmalkki@cc.hut.fi>");
./drivers/input/keyboard/omap-keypad.c:MODULE_AUTHOR("Timo Ter�");
./drivers/isdn/hisax/isdnhdlc.c:MODULE_AUTHOR("Wolfgang M�s <wolfgang@iksw-muees.de>, "
./drivers/mmc/host/omap.c:MODULE_AUTHOR("Juha Yrj��);
./drivers/mtd/devices/phram.c:MODULE_AUTHOR("Jörn Engel <joern@wh.fh-wedel.de>");
./drivers/mtd/maps/cfi_flagadm.c:MODULE_AUTHOR("Kári Davíðsson <kd@flaga.is>");
./drivers/mtd/maps/dbox2-flash.c:MODULE_AUTHOR("Kári Davíðsson <kd@flaga.is>, Bastian Blank <waldi@tuxbox.org>, Alexander Wild <wild@te-elektronik.com>");
./drivers/net/irda/kingsun-sir.c:MODULE_AUTHOR("Alex Villac�s Lasso <a_villacis@palosanto.com>");
./drivers/scsi/aha152x.c:MODULE_AUTHOR("J�gen Fischer");
./drivers/scsi/sni_53c710.c:MODULE_AUTHOR("Thomas Bogend�fer");
./drivers/usb/misc/emi26.c:MODULE_AUTHOR("tapio laxstr�");
./drivers/usb/misc/emi62.c:MODULE_AUTHOR("tapio laxstr�");

So, we had some ISO8859-1 and some UTF-8 in there already. (And as for 
MODULE_AUTHOR, it should stay there - 'fix' modinfo instead.)


BTW, there's also still a ton of non-UTF-8 in the kernel; I've already
fixed that weeks ago and sent some patch to trivial@, Adrian -
did you receive it?



	Jan
-- 
---699020219-538899979-1181315791=:10769--
