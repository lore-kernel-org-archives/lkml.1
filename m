Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbXDBPoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbXDBPoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932738AbXDBPoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:44:12 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:6139 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932700AbXDBPoL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:44:11 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Questions regarding ACPI vs FADT dump on HP XW6200 using 2.6.16 - 2.6.20 kernels?
Date: Mon, 2 Apr 2007 11:43:37 -0400
Message-ID: <8E8F647D7835334B985D069AE964A4F7033AB5BC@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Questions regarding ACPI vs FADT dump on HP XW6200 using 2.6.16 - 2.6.20 kernels?
Thread-Index: Acd1Hh9Sb1eMatUVTo2qKsRYY4rSzQAHOpoA
References: <56464.192.54.193.51.1175515024.squirrel@rousalka.dyndns.org>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Apr 2007 15:43:38.0004 (UTC) FILETIME=[AE3D0D40:01C7753D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In reference to this Bugzilla entry:
http://bugzilla.kernel.org/show_bug.cgi?id=7110

I'm getting ACPI errors in the dmesg:
[    7.443482] ACPI Error (evgpe-0711): No handler or method for GPE[
0], disabling event [20060707]
[    7.449881] ACPI Error (evgpe-0711): No handler or method for GPE[
1], disabling event [20060707]
[    7.456145] ACPI Error (evgpe-0711): No handler or method for GPE[
2], disabling event [20060707]
[    7.462271] ACPI Error (evgpe-0711): No handler or method for GPE[
5], disabling event [20060707]
[    7.468310] ACPI Error (evgpe-0711): No handler or method for GPE[
6], disabling event [20060707]
[    7.474260] ACPI Error (evgpe-0711): No handler or method for GPE[
7], disabling event [20060707]
[    7.480124] ACPI Error (evgpe-0711): No handler or method for GPE[
9], disabling event [20060707]
[    7.485893] ACPI Error (evgpe-0711): No handler or method for GPE[
A], disabling event [20060707]
[    7.491473] ACPI Error (evgpe-0711): No handler or method for GPE[
F], disabling event [20060707]
[    7.491484] ACPI Error (evgpe-0711): No handler or method for
GPE[10], disabling event [20060707]
[    7.491489] ACPI Error (evgpe-0711): No handler or method for
GPE[11], disabling event [20060707]
[    7.491494] ACPI Error (evgpe-0711): No handler or method for
GPE[12], disabling event [20060707]
[    7.491499] ACPI Error (evgpe-0711): No handler or method for
GPE[13], disabling event [20060707]
[    7.491504] ACPI Error (evgpe-0711): No handler or method for
GPE[14], disabling event [20060707]
[    7.491509] ACPI Error (evgpe-0711): No handler or method for
GPE[15], disabling event [20060707]
[    7.491514] ACPI Error (evgpe-0711): No handler or method for
GPE[16], disabling event [20060707]
[    7.491519] ACPI Error (evgpe-0711): No handler or method for
GPE[17], disabling event [20060707]
[    7.491527] ACPI Error (evgpe-0711): No handler or method for
GPE[19], disabling event [20060707]
[    7.491532] ACPI Error (evgpe-0711): No handler or method for
GPE[1A], disabling event [20060707]
[    7.491537] ACPI Error (evgpe-0711): No handler or method for
GPE[1B], disabling event [20060707]
[    7.491542] ACPI Error (evgpe-0711): No handler or method for
GPE[1C], disabling event [20060707]
[    7.491547] ACPI Error (evgpe-0711): No handler or method for
GPE[1D], disabling event [20060707]
[    7.491552] ACPI Error (evgpe-0711): No handler or method for
GPE[1E], disabling event [20060707]
[    7.491557] ACPI Error (evgpe-0711): No handler or method for
GPE[1F], disabling event [20060707]

The ACPI: FADT dmesg entry is:
[    0.000000] ACPI: RSDP (v002 COMPAQ                                )
@ 0x000e8e10
[    0.000000] ACPI: XSDT (v001 COMPAQ CPQ0063  0x20051222  0x00000000)
@ 0xbfff50ec
[    0.000000] ACPI: FADT (v003 COMPAQ TUMWATER 0x00000001  0x00000000)
@ 0xbfff52ac
[    0.000000] ACPI: SSDT (v001 COMPAQ  PROJECT 0x00000001 MSFT
0x0100000e) @ 0xbfff657a
[    0.000000] ACPI: MADT (v001 COMPAQ TUMWATER 0x00000001  0x00000000)
@ 0xbfff53b8
[    0.000000] ACPI: ASF! (v032 COMPAQ TUMWATER 0x00000001  0x00000000)
@ 0xbfff543c
[    0.000000] ACPI: MCFG (v001 COMPAQ TUMWATER 0x00000001  0x00000000)
@ 0xbfff54a6
[    0.000000] ACPI: DSDT (v001 COMPAQ     DSDT 0x00000001 MSFT
0x0100000e) @ 0x00000000

I've been told to use this command to dump this memory segment:
dd if=/dev/mem skip=$[0xbfff52ac] bs=1c count=244 2> /dev/null >
fadt.bin
But I'm always getting an empty file?

My questions are:
1) How can I dump the FADT ?
2) Could this be related to this memory detection bug
http://bugzilla.kernel.org/show_bug.cgi?id=7111 ?

Thnx!

- vin
