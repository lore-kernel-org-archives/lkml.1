Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbXD0FcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbXD0FcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXD0FcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:32:12 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2857 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747AbXD0FcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:32:11 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: Pin an IRQ to a particular CPU
Date: Thu, 26 Apr 2007 22:31:28 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEJJDFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <2fe399760704261815i428105d4qddc2648688e694bc@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 26 Apr 2007 23:31:47 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 26 Apr 2007 23:31:48 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hello,
> 
> In an effort to increase over all throughput of my Linux NFS file
> server, I thought about trying to force an IRQ, for the NIC, to be
> serviced by a particular CPU.  Is this possible?
> 
> TIA,
> Phy

/proc/irq/*/smp_affinity

I would recommend automatic balancing and leave it at that. This code automatically distributes IRQs to CPUs such that each IRQ can only be serviced by a single CPU and the IRQs are distributed over the CPU set.

DS


