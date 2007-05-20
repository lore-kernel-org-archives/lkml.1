Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbXETNBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbXETNBc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 09:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbXETNBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 09:01:25 -0400
Received: from khc.piap.pl ([195.187.100.11]:48399 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755649AbXETNBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 09:01:25 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.22-rc2: make -j makes it unresponsive
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
	<200705201457.26716.rjw@sisk.pl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 20 May 2007 15:01:23 +0200
In-Reply-To: <200705201457.26716.rjw@sisk.pl> (Rafael J. Wysocki's message of "Sun, 20 May 2007 14:57:26 +0200")
Message-ID: <m3hcq7k5ss.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> Running 'make -j' kernel compilation on my test box (Athlon64 X2, 2 SATA
> drives
> with 6 software RAID1 ext3 and reiserfs partitions, 2 GB of RAM) makes it
> completely unresponsive.  I can't even move the mouse pointer when it's
> running, I can't log to the box from the network etc.

How many processes does it spawn? Try some sane limit.
-- 
Krzysztof Halasa
