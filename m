Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbXBEIX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbXBEIX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 03:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752139AbXBEIX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 03:23:28 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2041 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbXBEIX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 03:23:27 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <zhangxiliang@nanjing-fnst.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: ntp
Date: Mon, 5 Feb 2007 00:22:42 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEAJBGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <00b201c748ca$3aa95cc0$2801a8c0@zhangxiliang>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Mon, 05 Feb 2007 00:23:08 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Mon, 05 Feb 2007 00:23:09 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hello.
> When I use the ntpd service, I see if I use the client attempt to connect
> the server repeat before the server is ready, the ntpd on server
> can not be
> ready all the times.
>
> Sometimes the waiting time maybe very long.

Sounds like NTP is the wrong tool for the job. NTP is specifically designed
to synchronize clocks with high accuracy to timing sources traceable to UTC.
It requires stable servers in order to do that. There are any number of
other time settings tools that don't try to actually synchronize clocks.

DS



