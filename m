Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYK1He0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYK1He0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 02:34:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbYK1HeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 02:34:16 -0500
Received: from ext-cn0ut-6.online-age.net ([63.210.253.235]:54135 "EHLO
	ext-cn0ut-6.online-age.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbYK1HeP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 02:34:15 -0500
X-Greylist: delayed 3522 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2008 02:34:15 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: DMA from memory to local bus
Date: Fri, 28 Nov 2008 07:35:28 +0100
Message-ID: <62DDBB9E5E23CC4A929EE46F9427CEAF0162468D@BUDMLVEM04.e2k.ad.ge.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: DMA from memory to local bus
Thread-Index: AclRI4D7wuXV0/8HRZm2eu6olpR6RA==
From: "Hommel, Thomas (GE EntSol, Intelligent Platforms)" 
	<Thomas.Hommel@gefanuc.com>
To: <linux-kernel@vger.kernel.org>
Cc: <maciej.sosnowski@intel.com>, <dan.j.williams@intel.com>
X-OriginalArrivalTime: 28 Nov 2008 06:35:32.0309 (UTC) FILETIME=[832AB850:01C95123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I'm currently developing a driver and want to make use of the DMA
offload engine. Data has to be transferred from memory to a device on
the local bus and vice versa.
At a first look, the function dma_async_memcpy_buf_to_buf() seemed to be
suitable, but it does not translate addresses correctly. Both addresses
are treated as if they were in memory.
In my configuration, the buffer is located in memory, but the device's
I/O space is mapped into vmalloc space via ioremap(). How can I access
the I/O space corectly from the DMA controller?

Thanks for your help
Thomas
