Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbXKWGHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbXKWGHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 01:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbXKWGHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 01:07:44 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:1379 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbXKWGHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 01:07:43 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Subject: RE: [RFC/PATCH] SO_NO_CHECK for IPv6
Date: Thu, 22 Nov 2007 22:06:35 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEFLIGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <20071122.171306.166854987.davem@davemloft.net>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 22 Nov 2007 22:07:40 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 22 Nov 2007 22:07:41 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Regardless of whatever verifications your application is doing
> on the data, it is not checksumming the ports and that's what
> the pseudo-header is helping with.

So what? We are in the case where the data has already gotten to him. If it
got to him in error, he'll reject it anyway. The receive checksum check will
only reject packets that he would reject anyway. That makes it needless.

Of course, if the check is nearly free, there's no potential win, so no
point in bothering.

DS


