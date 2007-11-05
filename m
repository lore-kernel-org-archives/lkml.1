Return-Path: <linux-kernel-owner+w=401wt.eu-S1755043AbXKEWeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbXKEWeh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 17:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXKEWe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 17:34:29 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:55003 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbXKEWe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 17:34:28 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <472F9A27.7070304@s5r6.in-berlin.de>
Date: Mon, 05 Nov 2007 23:33:11 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Greg KH <greg@kroah.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, apw <apw@shadowen.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: device struct bloat
References: <20071103124823.6059640e@shemminger-laptop>	 <1194208158.5911.63.camel@lappy>  <20071105035855.GA25511@kroah.com>	 <1194259581.27652.418.camel@twins> <1194260234.27652.425.camel@twins>
In-Reply-To: <1194260234.27652.425.camel@twins>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
[sem-to-mutex in struct device and struct class]
>  drivers/base/bus.c                |   20 ++++++++++----------
>  drivers/base/class.c              |   22 +++++++++++-----------
>  drivers/base/core.c               |   20 +++++++++-----------
>  drivers/base/dd.c                 |   38 +++++++++++++++++++-------------------
>  drivers/base/power/main.c         |    8 ++++----
>  drivers/pci/bus.c                 |    4 ++--
>  drivers/pnp/interface.c           |   10 +++++-----
>  drivers/pnp/manager.c             |   18 +++++++++---------
>  drivers/power/power_supply_core.c |    8 ++++----
>  drivers/rtc/interface.c           |    4 ++--
>  drivers/scsi/hosts.c              |    4 ++--
>  drivers/spi/spi.c                 |   10 +++++-----
>  drivers/usb/core/hub.c            |    4 ++--
>  include/linux/device.h            |   18 +++++++++++-------
>  include/linux/usb.h               |    6 +++---
>  15 files changed, 98 insertions(+), 96 deletions(-)

At least two files are missing:
drivers/firewire/fw-device.c accesses device.sem.
drivers/ieee1394/nodemgr.c accesses class.sem and device.sem.
-- 
Stefan Richter
-=====-=-=== =-== ---=-
http://arcgraph.de/sr/
