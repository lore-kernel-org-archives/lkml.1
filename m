Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbZAKPMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbZAKPMf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 10:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZAKPMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 10:12:23 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44080 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbZAKPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 10:12:23 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <496A0C4E.5040502@s5r6.in-berlin.de>
Date: Sun, 11 Jan 2009 16:12:14 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: joseluismarchetti@yahoo.com.br
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: MAC address runtime configuration in new driver (was Re: ...no subject)
References: <204164.94418.qm@web34403.mail.mud.yahoo.com>
In-Reply-To: <204164.94418.qm@web34403.mail.mud.yahoo.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jose Luis Marchetti wrote:
> Hi,
> 
> I would like to open/read/write/close a regular file from my device
> driver.
> I think it would be possible, but I am confused, the "The Linux Kernel
> Module Programming Guide" states that I can not use standard libraries
> from within a module, I know the standard library ends up calling
> system calls, but which calls should I use to deal with regular
> files ?

http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad discusses this.

> I am developing a Ethernet driver and the Mac address configuration
> 
> Thanks in advance!
> 
> José Luís Marchetti

Userspace could write the necessary configuration data into the kernel,
for example a sysfs attribute.  Of course the attribute could also be
readable.  But perhaps there are already established mechanisms for
exactly this purpose.  I added Cc: netdev, maybe somebody there can give
advice.
-- 
Stefan Richter
-=====-==--= ---= -=-==
http://arcgraph.de/sr/
