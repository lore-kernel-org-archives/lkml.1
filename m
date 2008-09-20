Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbYITXlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbYITXlx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 19:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbYITXlp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 19:41:45 -0400
Received: from web37502.mail.mud.yahoo.com ([209.191.91.149]:27941 "HELO
	web37502.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751539AbYITXlo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 19:41:44 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Sep 2008 19:41:44 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=sma1lWx+X8Aka3Yt5nzh9GUKUzOEqXlAQjqzsTDbTiSN4tmDa/oMzRcHT28sjCSZqHE7LjA9MmO+PZyySnlHb8VDgRl71OMQEgidkV2Exsk+BDsFwZcOJrf29G0ysETGvTXdJThRs4aXD2/ex00KzKJHXJ+S09XL8k/yQR70C2g=;
X-YMail-OSG: xooi.EEVM1nSL5ycRbyiAt_9blLJ1Yp1KW4MnNajdr.mDCQ1IKX8POncP6GeYWUnjapQgQAls9acRdsqmCwhxTxcoplJLSpgkShZj2vjPwuEvjF8DDSvA4QUqdaAEJIAqViWmSiEaJYuXgECmZ33uTAV4oOSBA--
X-Mailer: YahooMailWebService/0.7.218.2
Date: Sat, 20 Sep 2008 16:35:03 -0700 (PDT)
From: =?iso-8859-1?Q?cihan_=F6zt=FCrk?= <cihanozturk@yahoo.com>
Reply-To: cihanozturk@yahoo.com
Subject: USB driver problem with external hub
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <684433.70774.qm@web37502.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on a device driver for providing connectivity to a Silabs
F340 board through USB. All the required software, including firmware
on the device side, USB device driver and user level libraries as well
as the application, are implemented. The system operates fine when
experimental communication is considered, in which dummy data is
simply sent and received betweeen the host and the device at Full
speed. The trouble comes when a USB external hub is used as a gateway
between the device and the host instead of directly connecting the USB
cable from device to the USB port of the PC. The kernel log states
that the transfer of urb failed due to -EPROTO(-71), which is defined
as protocol error. I found in some resources that this error can be a
result of (a) bitstuff error, or (b) no response packet received
within the prescribed bus turn-around time, or (c)hardware problems
such as bad devices (including firmware) or cables.
The hub is a Digitus product with 7 ports and works fine with other
USB devices such as the mouse on the same platform.
My kernel version is 2.6.18.
Has anyone got any idea on what can be the reason of this failure, and
how can I resolve the problem? I can surely provide any additional
information about the situation if any one is interested in helping
out.
Thanks... 
--------------
Cihan Ozturk


      
