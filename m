Return-Path: <linux-kernel-owner+w=401wt.eu-S1751295AbXA0JqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbXA0JqM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 04:46:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751125AbXA0JqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 04:46:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34649 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbXA0JqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 04:46:10 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <45BB1F42.4000404@s5r6.in-berlin.de>
Date: Sat, 27 Jan 2007 10:45:38 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20070121 SeaMonkey/1.0.7
MIME-Version: 1.0
To: Pieter Palmers <pieterp@joow.be>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-rt2: kernel oops when ejecting cardbus firewire card
References: <45BA743B.2080401@joow.be> <45BA85A1.1030707@s5r6.in-berlin.de>	<45BB106E.706@joow.be> <45BB14A7.6040400@s5r6.in-berlin.de> <45BB18DE.1090802@joow.be>
In-Reply-To: <45BB18DE.1090802@joow.be>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pieter Palmers wrote:
> OTOH, dv1394 is scheduled for removal. Not that we should tolerate bugs
> in the Linux kernel ;), but it lowers priority I guess.

It does. (Plus I didn't have a Linux box with CardBus slot in operation
for a while, but now I have.)

> For me the solution is simple: I don't need dv1394, so I just don't
> build it anymore. It has the annoying tendency to auto-load when raw1394
> is loaded.

This is a correlation but not a causality. dv1394's and raw1394's
_device_id tables for driver matching both match AV/C devices.
-- 
Stefan Richter
-=====-=-=== ---= ==-==
http://arcgraph.de/sr/
