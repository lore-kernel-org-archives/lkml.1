Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbXAXVT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbXAXVT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 16:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXAXVT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 16:19:56 -0500
Received: from mail29.messagelabs.com ([216.82.249.147]:43961 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752050AbXAXVTz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 16:19:55 -0500
X-VirusChecked: Checked
X-Env-Sender: Scott_Kilau@digi.com
X-Msg-Ref: server-5.tower-29.messagelabs.com!1169673594!29840684!1
X-StarScan-Version: 5.5.10.7.1; banners=-,-,-
X-Originating-IP: [66.77.174.21]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: Re: Strange problem with tty layer
Date: Wed, 24 Jan 2007 15:19:53 -0600
Message-ID: <335DD0B75189FB428E5C32680089FB9F012DCACD@mtk-sms-mail01.digi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Re: Strange problem with tty layer
Thread-Index: Acc//WS/Jid8cj1hQEGs0os0Dc3djg==
From: "Kilau, Scott" <Scott_Kilau@digi.com>
To: <lsorense@csclub.uwaterloo.ca>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 24 Jan 2007 21:19:54.0233 (UTC) FILETIME=[641E4690:01C73FFD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

> I am seeing a very strange problem which seems to be in the tty layer.
> 
> I am using an exar 17D154 based PCI card (like the digi neo style
card)
> using the jsm driver.  Kernel version 2.6.16.25.

There are a couple interesting things I would do here.

1) The tty "flip" buffer stuff was changed in 2.6.16+.

Maybe you could try going downwards to 2.6.15 or below and see if the
problem
still exists.

Then try going up to 2.6.19, I believe there were some bugs fixed
in 2.6.17/18/19, not sure how many of those made it backported into
2.6.16.25.

2) Try using Digi's "Out-Of-Kernel-Source-Tree"/GPL version of the
driver.
You can grab the latest and greatest beta version of it from here:
ftp://ftp1.digi.com/support/beta/linux/dgnc/
Its in source rpm format, let me know if you need it in a tarball format
instead.

You obviously will have to add in your specific PCI id into the driver,
but that should be a problem.

3) I seem to recall that someone mentioned that the Exar 17D154 PCI
chips were
easily "pushed" into the 8250 driver.
It might be interesting to try that route as well.

Scott Kilau
