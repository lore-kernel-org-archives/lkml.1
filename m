Return-Path: <linux-kernel-owner+w=401wt.eu-S933064AbXB0QMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933064AbXB0QMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 11:12:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbXB0QMj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 11:12:39 -0500
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:55372 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933064AbXB0QMi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 11:12:38 -0500
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
Subject: RE: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
Date: Tue, 27 Feb 2007 11:12:06 -0500
Message-ID: <8E8F647D7835334B985D069AE964A4F7028FE5B0@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
Thread-Index: Acdah5tPzrWigVzIRNy/Qve1qcG3DAAAc6Lw
References: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe>  <45D5C789.1090607@student.ltu.se>  <8E8F647D7835334B985D069AE964A4F7028FE550@ECQCMTLMAIL1.quebec.int.ec.gc.ca>  <Pine.LNX.4.64.0702182216060.25686@twin.jikos.cz> <1171844733.2488.33.camel@violet> <Pine.LNX.4.64.0702271648190.10496@twin.jikos.cz>
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "Jiri Kosina" <jikos@jikos.cz>, "Marcel Holtmann" <marcel@holtmann.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 Feb 2007 16:12:07.0246 (UTC) FILETIME=[06FB2EE0:01C75A8A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> we understand the original CSR HID proxy dongles, but for the Logitech

> ones, it is wild guesses. The current support in hid2hci has been 
> tested on Logitech diNovo first generation and I have no other 
> Logitech hardware to verify it with. We might simply need 
> the full HID report descriptor to see who is at fault.
> 
> As far as I can see from a quick look, the device IDs are 
> unchanged (0x046d/0xc70e for the keyboard), but the report 
> descriptor seems to differ from the one you have at 
> http://www.holtmann.org/linux/bluetooth/logitech.html - that 
> seems pretty sad.
> 
> What puzzles me a bit is a fact that both the bugreporters 
> seem to state pretty clearly that this started happening 
> after some update, am I right?
> 
> Or did the hardware before work all the time in the HID mode, 
> without even being attempted to switch to HCI (which seems to 
> cause the bug)?
> 

Actually it's the first time I'm trying this keyboard and mouse.

- vin
