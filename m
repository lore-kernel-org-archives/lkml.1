Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZDGIje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZDGIje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 04:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZDGIjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 04:39:21 -0400
Received: from lnx503.hrz.tu-darmstadt.de ([130.83.156.232]:33735 "EHLO
	lnx503.hrz.tu-darmstadt.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbZDGIjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 04:39:20 -0400
X-Greylist: delayed 499 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2009 04:39:20 EDT
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18907.3900.117808.251116@elektron.ikp.physik.tu-darmstadt.de>
Date: Tue, 7 Apr 2009 10:30:52 +0200
To: Luotao Fu <l.fu@pengutronix.de>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: add FTDI FT4232H ID
In-Reply-To: <1239090573-11527-1-git-send-email-l.fu@pengutronix.de>
References: <1239090573-11527-1-git-send-email-l.fu@pengutronix.de>
X-Mailer: VM 7.19 under Emacs 21.3.1
X-PMX-TU: seen v0.62 by 5.5.3.366731, Antispam-Engine: 2.7.0.366912, Antispam-Data: 2009.4.7.81619
X-PMX-SPAMCHECK: outgoing mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Luotao" == Luotao Fu <l.fu@pengutronix.de> writes:

    Luotao> add the ID of FT4232H Hi-Speed quad channel serial converter.

This probably isn't enough to make the devices work.

The FT2232H and FT4432H are High Speed devices with defaul buffer sizes of
512 bytes. A recieve buffer contains two status bytes and then up to 510
bytes of data against 62 bytes on the old devices.

Bye
-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------
