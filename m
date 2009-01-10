Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbZAJP15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbZAJP15 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbZAJP1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:27:49 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:50103 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbZAJP1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:27:49 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4968BE74.1070903@gmail.com>
Date: Sat, 10 Jan 2009 15:27:48 +0000
From: Jonathan Cameron <Jonathan.Cameron@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Liam Girdwood <lrg@kernel.org>, Mark Brown <broonie@sirena.org.uk>
Subject: Regulator: Use case query (many devices need to reg their voltage
 requirements?)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

A quick request for comments w.r.t. specifying voltage requirements
of drivers that do not need to dynamically change their supply voltage.

Obviously for a given embedded system, it is possible to work out on
paper what regulator configuration works for all components connected to
a particular regulator as long as these connections are static.

A number of different embedded system now use main boards (core etc) in
conjunction with daughter boards.  In these cases different modules may
be inserted to support different daughter board options from a single kernel
(and combinations if possible).  Thus we have a situation in which the
appropriate voltage level can only be established if the various drivers
specify what they need. The board config may specify numerous devices
only some of which may actually be present.

This leads to additional complexity in numerous drivers as they have to act
as dynamic drivers (terminology from regulator docs) even though they don't
actually vary the voltage, merely specify what ranges they can work with.

Is this the best way to handle this situation, or do people have other
suggestions?

Thanks

Jonathan Cameron

