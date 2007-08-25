Return-Path: <linux-kernel-owner+w=401wt.eu-S933655AbXHYJMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655AbXHYJMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 05:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933172AbXHYJMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 05:12:41 -0400
Received: from corky.net ([212.150.53.130]:42628 "EHLO zebday.corky.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932667AbXHYJMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 05:12:40 -0400
X-Greylist: delayed 1523 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2007 05:12:40 EDT
Message-ID: <46CFEB36.9020806@corky.net>
Date: Sat, 25 Aug 2007 09:41:26 +0100
From: Just Marc <marc@corky.net>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070622)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: file system for solid state disks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP on CorKy.NeT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's important to note that disk-replacement type SSDs perform much 
better with very small block operations, generally 512 bytes.  So the 
lower your file system block size, the better -- this will be the single 
most significant performance tweak one should do.   This is true for the 
benchmarks I've seen where the difference between 4KB and 512Byte block 
sizes was almost 100%.   YMMV -- always benchmark.

On SSDs which contain built in wear leveling, pretty much any file 
system can be used.   For SSDs that lack such low level housekeeping, 
use stuff like JFFS2.

Marc
