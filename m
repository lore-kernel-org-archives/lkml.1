Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbZDGJq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbZDGJq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZDGJqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:46:47 -0400
Received: from lnx503.hrz.tu-darmstadt.de ([130.83.156.232]:37185 "EHLO
	lnx503.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751528AbZDGJqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:46:46 -0400
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18907.8396.397764.21716@elektron.ikp.physik.tu-darmstadt.de>
Date: Tue, 7 Apr 2009 11:45:48 +0200
To: Luotao Fu <l.fu@pengutronix.de>
Cc: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>, gregkh@suse.de,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: add FTDI FT4232H ID
In-Reply-To: <20090407090353.GA12669@pengutronix.de>
References: <1239090573-11527-1-git-send-email-l.fu@pengutronix.de>
	<18907.3900.117808.251116@elektron.ikp.physik.tu-darmstadt.de>
	<20090407090353.GA12669@pengutronix.de>
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v0.62 by 5.5.3.366731, Antispam-Engine: 2.7.0.366912, Antispam-Data: 2009.4.7.93123
X-PMX-SPAMCHECK: outgoing mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Luotao" == Luotao Fu <l.fu@pengutronix.de> writes:

    Luotao> On Tue, Apr 07, 2009 at 10:30:52AM +0200, Uwe Bonnes wrote:
    >> >>>>> "Luotao" == Luotao Fu <l.fu@pengutronix.de> writes:
    >> 
    Luotao> add the ID of FT4232H Hi-Speed quad channel serial converter.
    >>  This probably isn't enough to make the devices work.
    >> 
    >> The FT2232H and FT4432H are High Speed devices with defaul buffer
    >> sizes of 512 bytes. A recieve buffer contains two status bytes and
    >> then up to 510 bytes of data against 62 bytes on the old devices.

    Luotao> Shame on me. I did only check whether the device with its four
    Luotao> channels are registered. Since the chip is built-in on our board
    Luotao> and I still need some additional libraries to check the devices
    Luotao> connected to it. I haven't done any function tests still. Will
    Luotao> keep an eye on this. Sounds that it could be a little hairy
    Luotao> then. Afais the PID 6001 is e.g. shared by common/high speed
    Luotao> devices. I didn't grab deeper in the ftdi code, probably it'll
    Luotao> be some way to work around this.

For libusb access, some work for the H-Type chips has already been don in
libftdi (www.intra2net.com/en/developer/libftdi/)

-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
