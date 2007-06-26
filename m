Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbXFZOoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbXFZOoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 10:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbXFZOoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 10:44:11 -0400
Received: from lucidpixels.com ([75.144.35.66]:57013 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbXFZOoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 10:44:10 -0400
Date: Tue, 26 Jun 2007 10:44:10 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
cc: xfs@oss.sgi.com
Subject: Does anyone have a benchmark of chunk sizes with SW RAID5?
Message-ID: <Pine.LNX.4.64.0706261042490.3561@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am running one with 64,128,256,512,1024,2048,4096,8192,16384,32768,65536 
it it accepts up that high..  With XFS and _ALL_ default mount and 
filesystem settings to target this specific tunable.

p34:~# /usr/bin/time ./benchraid.sh
Tue Jun 26 10:25:21 EDT 2007: Creating RAID5 array with 64 chunk size...
Tue Jun 26 10:25:21 EDT 2007: Increasing RAID rebuild speed...
Tue Jun 26 10:25:21 EDT 2007: RAID is still building...
Tue Jun 26 10:35:21 EDT 2007: RAID is still building...

