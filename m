Return-Path: <linux-kernel-owner+w=401wt.eu-S1756447AbXI2Acz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbXI2Acz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbXI2Acr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:32:47 -0400
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:34935 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752310AbXI2Acq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:32:46 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6.23-rc8-mm2] System hangs (loops?) during boot
Date: Sat, 29 Sep 2007 02:32:44 +0200
User-Agent: KMail/1.9.7
References: <200709282225.21530.elendil@planet.nl>
In-Reply-To: <200709282225.21530.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709290232.44573.elendil@planet.nl>
X-OriginalArrivalTime: 29 Sep 2007 00:32:44.0993 (UTC) FILETIME=[40DC6310:01C80230]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007, Frans Pop wrote:
> My Toshiba Satellite A40 (i386, P4 Mobile) hangs during boot after:
> Marking TSC unstable due to: possible TSC halt in C2.
> Time: acpi_pm clocksource has been installed.

A few new boot attempts show the problem is more likely at:
Probing IDE interface ide0...

> It may not actually hang, but rather end up in a loop as after some time
> the fan goes wild.

Unfortunately I have no serial port and this seems too early for netconsole, 
so cannot catch a boot log.

> Any suggestions where to look before I do a bisect?
