Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbXJINuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbXJINuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 09:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbXJINu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 09:50:29 -0400
Received: from smile.2scale.net ([212.12.33.142]:39018 "EHLO smile.2scale.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbXJINu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 09:50:29 -0400
Subject: howto boost write(2) performance?
From: Michael Stiller <ms@2scale.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: 2scale GmbH
Date: Tue, 09 Oct 2007 15:50:17 +0200
Message-Id: <1191937817.3641.9.camel@blackberry>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

i'm developing an application (in C) which needs to write about 
1Gbit/s (125Mb/s) to a disk array attached via U320 SCSI. 
It runs on Dual Core 2 Xeons @2Ghz utilizing kernel 2.6.22.7. 

I buffer the data in (currently 4) 400Mb buffers and use write(2) in a
dedicated thread to write them to the raw disk (no fs). 

The write(2) performance is not good enough, the writer threads take to
much time, and i ask you for ideas, howto to boost the write
performance. 

Maybe mmaping the disk would work? 

Cheers,

-Michael

PS. I would like to be cc'd as i usually don't read the list due to high
traffic.

