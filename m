Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbZKJRMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbZKJRMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756638AbZKJRMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:12:06 -0500
Received: from router.emperor-sw2.exsbs.net ([208.254.201.37]:50080 "EHLO
	sade.emperorlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174AbZKJRMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:12:05 -0500
Subject: Seeking Guidance For Serial Driver Creation
From: Jeremy Moles <jeremy@emperorlinux.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 10 Nov 2009 11:50:47 -0500
Message-Id: <1257871847.2760.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on getting all of the hardware for a Panasonic CF-H1
supported. I am also interested in writing an OSS driver for the
internal barcode scanner device.

What I'm looking for is someone familiar with the serial API to take a
quick look at some data I've snooped from Windows' COM1 device--which I
acquired by running a serial snooping utility on the serial port from
the time that I push the "scan" button to the time it stops--and perhaps
offer a quick bit of advice on how I should proceed. I have a lot of
experience hacking EXISTING specialty drivers (things like pcc-acpi,
ibm-acpi, sony-acpi, sonypi, etc.) and I'm no stranger to low-level C
code, but this will be the first time I've written a serious driver from
scratch.

The information grokked from Windows can be found here:

	http://jeremymoles.com/scanner

I've divided it up as best I can; unfortunately, this data is exported
as-is from the Windows tool. The most interesting file is probably:

	http://jeremymoles.com/scanner/packet-view.html



Something to note is that unlike normal serial barcode scanners, the
actual "begin scanning" message isn't initiated by hardware. :( On a
traditional device it seems that you simply press a button on the
scanner and the text representation of that barcode is just dumped out
on the tty for you to read. In the case of this machine, a button on the
front (which must be handled in software) is pressed, and the OS takes
over and initializes the device and somehow informs it to "begin
scanning." I believe this is the function of the first few lines of each
of the files I've uploaded, but I could be wrong.

Thanks beforehand...

