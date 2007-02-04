Return-Path: <linux-kernel-owner+w=401wt.eu-S1752158AbXBDIAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbXBDIAt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 03:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXBDIAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 03:00:49 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1323 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbXBDIAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 03:00:48 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: ntp
Date: Sat, 3 Feb 2007 23:59:56 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKCELPBFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <026801c746a6$c3f81780$2801a8c0@zhangxiliang>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sun, 04 Feb 2007 00:00:08 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sun, 04 Feb 2007 00:00:09 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> When i start the ntp service successful on server, the client must ntpdate
> with the server after waiting a moment.
> The moment may be 3~5 minutes, or it may be 10~15 minutes. I
> don't know why
> it happens?

Two clocks cannot be synchronized instantaneously. It takes time to compare
the two clocks and adjust so that they stay in sync. A client will not
accept a date from an NTP server whose clock is not synchronized -- why
should it?

Imagine this -- you have a clock you do not trust. You ask a clock you do
trust what time it is, and it tells you it is 10:00. A bit later, I ask you
what time it is. Your clock says 10:12. Can you trust that time? Your clock
may be fast, it may be slow. You don't know. Until you check the clock you
trust a few times and confirm both clocks are flowing at the same rate, you
cannot tell the client what time it is when it asks you.

DS


