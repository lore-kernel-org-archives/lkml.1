Return-Path: <linux-kernel-owner+w=401wt.eu-S1752580AbXBJBUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbXBJBUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 20:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbXBJBUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 20:20:12 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:25119 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbXBJBUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 20:20:11 -0500
Date: Fri, 09 Feb 2007 19:19:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Strange message in log upon resuming a PCIe system
In-reply-to: <fa.uIwUWn6+JKZKUXoPwWOx9LXPFRE@ifi.uio.no>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <45CD1DA5.1060801@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.uIwUWn6+JKZKUXoPwWOx9LXPFRE@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger wrote:
> A bcm43xx user is having problems with suspend/resume with a PCIe system. This may be the first time
> we have tried to resume with PCIe. The problem occurs someplace within the initialization of the
> bcm43xx chip and we are still tracing it; however, there are some strange messages in the log from
> the pnp, namely:
> 
> pnp: Device 00:04 does not support activation.
> pnp: Device 00:05 does not support activation.
> 
> How does one trace back these device numbers? The output of 'lspci -v' shows the following:

Those aren't PCI devices, they're PnP devices, likely on the 
motherboard. If you look in sysfs (not booted into Linux right now so I 
can't tell you exactly where) you can get some idea of what those are. 
In any case I think those are messages are harmless and unrelated to any 
bcm43xx problems.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

