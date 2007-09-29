Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbXI2Ryx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbXI2Ryx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 13:54:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXI2Ryr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 13:54:47 -0400
Received: from mail.tmr.com ([64.65.253.246]:49499 "EHLO posidon.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713AbXI2Ryq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 13:54:46 -0400
Message-ID: <46FE9164.4090008@tmr.com>
Date: Sat, 29 Sep 2007 13:54:44 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: 2.6.23-rc8 - Hangcheck on resume from x2mem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I find this in dmesg after resume from s2mem:

    Hangcheck: hangcheck value past margin!

System: ASUS P5LD2-VM board, Intel 6600 CPU at 2.40 GHz (no o/c) 2GB 
RAM, 3x320GB SATA sw RAID-5. FC6 distribution, fully updated, suspend 
via "system" menu pulldown.

Just in case this is of interest, the resume and suspend work without 
suspend2 patching, although since it's a server and has mains power it's 
only of interest for testing.

USB backup devices were *not* connected.

-- 
Bill Davidsen
  He was a full-time professional cat, not some moonlighting
ferret or weasel. He knew about these things.

