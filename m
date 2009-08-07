Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbZHGWvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbZHGWvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 18:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZHGWvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 18:51:31 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:52032 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832AbZHGWv3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 18:51:29 -0400
Date: Sat, 08 Aug 2009 00:51:29 +0200
Message-Id: <859079895@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Martin Rogge <marogge@onlinehome.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.30.1-4 kernels freezes dual pentium-3 system
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/zX7wA/f7z/Vst6VMCxkGuLnhr6smTJ3KmQ1kMyl384ev2/
 QRp33BvffTQl59BgcSeOGu+iGElamjC5j4eWmbOI2LvHdzh02w=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Box  works  works fine and very stable under 2.6.29.5 kernel, although
>it is angry of buggy MP table (see app. #2 below). But sometimes, this
>kernel  correctly  reboots  the  system  at all, but this happens very
>rarely.  In  most cases, nobody detects the box was rebooted. And this
>is satisfactory for me.

so, what is it - stable or not stable ?

if sometimes "this kernel correctly reboots the system", do you mean that
happens spontaneously, i.e. without being actively triggered ?

how can this box work fine then or at least being considered "stable" then ?

there is already an issue there, and if it behaves different with 2.6.30, it
may be that the newer kernel triggers the existing problem in a different 
way.

>As I said earlier, bisecting may be unpractical, because each iteration may 
>take days or weeks.
afaik, you can also bisect on a different (i.e. faster) box.

i think it would be more interesting if there is anything in dmesg on such lockup.
if not, maybe you can hook up a serial console or netconsole and trigger sysrq when 
you have another lockup.

regards
roland



List:       linux-kernel
Subject:    2.6.30.1-4 kernels freezes dual pentium-3 system
From:       Осипов Станислав
Date:       2009-08-03 8:44:26
Message-ID: 569920565.20090803124426 () mail ! ru
[Download message RAW]

I  have  a  dual  Pentium-3 system. It based on Asus CUR-DLS mainboard
with  2  Pentium-3EB  1000MHz (133 MHz FSB) installed. Also, i'm using
hardware  RAID  controller  3ware  Escalade 7506-4LP, installed in the
PCI-X  expansion  slot.  This  RAID is only one disk system in the box
(RAID-5 on 4 IDE HDD 120GB from Seagate).

Box  works  works fine and very stable under 2.6.29.5 kernel, although
it is angry of buggy MP table (see app. #2 below). But sometimes, this
kernel  correctly  reboots  the  system  at all, but this happens very
rarely.  In  most cases, nobody detects the box was rebooted. And this
is satisfactory for me.

But  under 2.6.30.x kernels box freezes without any alerts. TTL before
freezing  is  about 5-30 mins. I don't know why that shit happens. I'm
ready to send any debug informations about this custom trouble, but if
the specialists will request it with instructions for me.

Appendix #1: lspci

======================================================================

00:00.0 Host bridge: Broadcom CNB20LE Host Bridge (rev 05)
00:00.1 Host bridge: Broadcom CNB20LE Host Bridge (rev 05)
00:02.0 Ethernet controller: Intel Corporation 82557/8/9/0/1 Ethernet Pro 100 (rev \
08) 00:04.0 Ethernet controller: 3Com Corporation 3c905B 100BaseTX [Cyclone]
00:07.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
00:0f.0 ISA bridge: Broadcom OSB4 South Bridge (rev 50)
00:0f.1 IDE interface: Broadcom OSB4 IDE Controller
01:02.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5701 Gigabit Ethernet \
(rev 15) 01:03.0 RAID bus controller: 3ware Inc 7xxx/8xxx-series PATA/SATA-RAID (rev \
01) 01:05.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 Ultra3 SCSI \
Adapter (rev 01) 01:05.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 \
Ultra3 SCSI Adapter (rev 01)

________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
f�r nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

