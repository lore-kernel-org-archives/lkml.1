Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYJ1LSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYJ1LSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 07:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYJ1LSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 07:18:09 -0400
Received: from ppsw-5.csi.cam.ac.uk ([131.111.8.135]:46192 "EHLO
	ppsw-5.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301AbYJ1LSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 07:18:08 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4906F500.7080100@cam.ac.uk>
Date: Tue, 28 Oct 2008 11:18:24 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: eric miao <eric.y.miao@gmail.com>, Liam Girdwood <lrg@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [Regulator RFC] da903x: Where should usb charge pump support go?
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

The new da903x driver is proving to be a good replacement for the out of kernel
driver I've been using previously.

Unfortunately there is still quite a lot of functionality to to add.

The key one for me is control of the USB charge pump. So the question is, does
this fit within the regulator framework (i.e. should I add it to the regulator
driver) or should this be a seperate driver (and if so where?)

Personally I'm not convinced it fits cleanly within the regulator framework
given it is probably only ever going to get called from one driver and has
somewhat odd properties!

Thanks,

Jonathan Cameron


