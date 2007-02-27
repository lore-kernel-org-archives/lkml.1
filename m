Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbXB0Pyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbXB0Pyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 10:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbXB0Pyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 10:54:45 -0500
Received: from twin.jikos.cz ([213.151.79.26]:34759 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751652AbXB0Pyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 10:54:44 -0500
Date: Tue, 27 Feb 2007 16:54:27 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Marcel Holtmann <marcel@holtmann.org>
cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>,
       linux-kernel@vger.kernel.org
Subject: Re: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
In-Reply-To: <1171844733.2488.33.camel@violet>
Message-ID: <Pine.LNX.4.64.0702271648190.10496@twin.jikos.cz>
References: <1171627435.6127.0.camel@wriver-t81fb058.linuxcoe> 
 <45D5C789.1090607@student.ltu.se>  <8E8F647D7835334B985D069AE964A4F7028FE550@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
  <Pine.LNX.4.64.0702182216060.25686@twin.jikos.cz> <1171844733.2488.33.camel@violet>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Feb 2007, Marcel Holtmann wrote:

> we understand the original CSR HID proxy dongles, but for the Logitech 
> ones, it is wild guesses. The current support in hid2hci has been tested 
> on Logitech diNovo first generation and I have no other Logitech 
> hardware to verify it with. We might simply need the full HID report 
> descriptor to see who is at fault.

As far as I can see from a quick look, the device IDs are unchanged 
(0x046d/0xc70e for the keyboard), but the report descriptor seems to 
differ from the one you have at 
http://www.holtmann.org/linux/bluetooth/logitech.html - that seems pretty 
sad.

What puzzles me a bit is a fact that both the bugreporters seem to state 
pretty clearly that this started happening after some update, am I right?

Or did the hardware before work all the time in the HID mode, without even 
being attempted to switch to HCI (which seems to cause the bug)?

-- 
Jiri Kosina
