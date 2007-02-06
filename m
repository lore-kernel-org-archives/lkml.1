Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbXBFULu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbXBFULu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:11:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965408AbXBFULu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:11:50 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1125 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965407AbXBFULu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:11:50 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Problem with unix sockets: SOCK_DGRAM ignores MSG_TRUNC
Date: Tue, 6 Feb 2007 12:11:31 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEKJBGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <200702061355.39660.daniel.kabs@mobotix.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 06 Feb 2007 12:11:46 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 06 Feb 2007 12:11:48 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Why not improve consistency and make unix_dgram_recvmsg() return the full
> packet length? So it would behave as UDP does. What do you think about
> adding the following code to linux/net/unix/af_unix.c:

It would be nice if the world worked that way, but you can't break POSIX
compliance. Perhaps another receive flag?

DS


