Return-Path: <linux-kernel-owner+w=401wt.eu-S932207AbXCXQiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbXCXQiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 12:38:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXCXQiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 12:38:06 -0400
Received: from lucidpixels.com ([75.144.35.66]:47020 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932207AbXCXQiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 12:38:04 -0400
Date: Sat, 24 Mar 2007 12:38:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
Subject: Why is NCQ enabled by default by libata? (2.6.20)
Message-ID: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Without NCQ, performance is MUCH better on almost every operation, with 
the exception of 2-3 items.

/usr/sbin/bonnie++ -d /x/bonnie -s 7952 -m p34 -n 16:100000:16:64 > run.txt;

# Average of 3 runs with NCQ on for Quad Raptor ADFD 150 RAID 5 Software RAID:
p34-ncq-on,7952M,43916.3,96.6667,151943,28.6667,75794.3,18.6667,48991.3,99,181687,24,558.033,0.333333,16:100000:16/64,867.667,9,29972.7,98.3333,2801.67,16,890.667,9.33333,27743,94.3333,2115.33,15.6667
# Average of 3 runs with NCQ off for Quad Raptor ADFD 150 RAID 5 Software RAID:
p34-ncq-off,7952M,42470,97.3333,200409,36.3333,90240.3,22.6667,48656,99,198853,27,546.467,0,16:100000:16/64,972.333,10,21833,72.3333,3697,21,995,10.6667,27901.7,95.6667,2681,20.6667

http://home.comcast.net/~jpiszcz/ncq_vs_noncq/results.html

In general, for networking, etc, the kernel chooses 'optimized' defaults, 
therefore, I was curious why is NCQ enabled by default?

Justin.
