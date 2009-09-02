Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbZIBQcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbZIBQcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 12:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZIBQcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 12:32:15 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:36665 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbZIBQcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 12:32:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XRloLAf9teoL2pk3UXcbJEJOMU7gXKm/thrCNo6Fze033uGnPeqJyYTcJk/QMJ1M6h
         QL4Nv7KaMpmZhdizg7LlEZAxcZks/p28VNPJ2g0CHHvHbppcA3HVLRvYg4I+AGu9hQNc
         Z4BKnJ5dHkm1Qm6JqtUz34tfpX0NZqMEf44V4=
MIME-Version: 1.0
Date: Wed, 2 Sep 2009 12:32:15 -0400
Message-ID: <fb7befa20909020932k74fa9e37x1eeabdb494835bb9@mail.gmail.com>
Subject: LowFree pattern
From: Adayadil Thomas <adayadil.thomas@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings.

I am running a centos linux with 2.6.20 version kernel. The system has
1G of RAM.

As time goes by the LowFree becomes really low. Right now it shows
137M .. but it goes as low as 8M or so

The command -
echo 3 > /proc/sys/vm/drop_caches
brings back the LowFree to way up high.

The question I have is whether the system by itself release the cache
(drop cache) automatically
to maintain a reasonable LowFree?
Is this configurable?

Any information or help is much appreciated.


cat /proc/meminfo
MemTotal:      1034788 kB
MemFree:        138240 kB
Buffers:         99260 kB
Cached:         177776 kB
SwapCached:      51740 kB
Active:         605172 kB
Inactive:       113572 kB
HighTotal:      130720 kB
HighFree:          252 kB
LowTotal:       904068 kB
LowFree:        137988 kB
SwapTotal:     1048568 kB
SwapFree:       976332 kB
Dirty:             380 kB
Writeback:           0 kB
AnonPages:      441348 kB
Mapped:          15540 kB
Slab:           146088 kB
SReclaimable:   104288 kB
SUnreclaim:      41800 kB
PageTables:       1596 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   1565960 kB
Committed_AS:   590576 kB
VmallocTotal:   114680 kB
VmallocUsed:     15052 kB
VmallocChunk:    99348 kB
