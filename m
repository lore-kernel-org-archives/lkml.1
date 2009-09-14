Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbZINJqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbZINJqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 05:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbZINJqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 05:46:12 -0400
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:42409 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179AbZINJqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 05:46:11 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net 2C7BA257450
Message-ID: <4AAE10E6.2050403@arcor.de>
Date: Mon, 14 Sep 2009 12:46:14 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Phoronix CFS vs BFS bencharks
References: <20090906205952.GA6516@elte.hu>
In-Reply-To: <20090906205952.GA6516@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phoronix has published some benchmarks, including some "non-synthetic" 
real-life applications:

   http://www.phoronix.com/vr.php?view=14179

The benchmarks are:

  * World of Padman
  * Timed Apache Compilation
  * Timed PHP Compilation
  * 7-Zip Compression
  * GraphicsMagick
  * Apache Benchmark
  * Threaded I/O Tester
  * PostMark

The test was performed on an Ubuntu 9.10 daily snapshot from 2009-09-10 
with the GNOME 2.27.91 desktop, X Server 1.6.3, NVIDIA 190.32 display 
driver, GCC 4.4.1, and an EXT4 file-system.
