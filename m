Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbZE3G1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbZE3G1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 02:27:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZE3G1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 02:27:00 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:31438 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbZE3G1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 02:27:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Ktjh8BFourDZVYjuBKJfIqXsnQbX0F3eugu0/3a7odhfjkrAaIHBurza9xeZaifPAq
         UvhIyghp9VtJ0W634eudbSm2/st6kcrtLDFKot9Iv2+ptv1mhQxD/jbM730ctxyQyI+I
         YaHttnc+F6gnOIzDzkJvxymoKn9GLeMbcHUKY=
MIME-Version: 1.0
Date: Sat, 30 May 2009 14:27:01 +0800
Message-ID: <30c949580905292327s1f3b8e32n3f7d7e3a15908c58@mail.gmail.com>
Subject: memory free question?
From: Bill Xie <bill790@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My harware is a mips-achitecture hand-hold device runs 2.6.24.3 and
qt.  when an application program  opened a 3.2M pdf file, the memory
was consuming continually, finally the "oom-killer" things happened,
but the memory the application occupied can not be freed.

cat /proc/meminfo
MemTotal:        60288 kB
MemFree:          5100 kB
Buffers:             8 kB
Cached:          25600 kB
SwapCached:          0 kB
Active:          21836 kB
Inactive:        15448 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:               0 kB
Writeback:           0 kB
AnonPages:       11740 kB
Mapped:           1668 kB
Slab:             2532 kB
SReclaimable:      308 kB
SUnreclaim:       2224 kB
PageTables:        164 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:     30144 kB
Committed_AS:    15656 kB
VmallocTotal:  1048404 kB
VmallocUsed:      9700 kB
VmallocChunk:  1038704 kB
