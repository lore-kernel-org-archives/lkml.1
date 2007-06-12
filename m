Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbXFLAau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbXFLAau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 20:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbXFLAam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 20:30:42 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:2768 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbXFLAal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 20:30:41 -0400
Message-ID: <466DE921.9030709@debianpt.org>
Date: Tue, 12 Jun 2007 01:30:25 +0100
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: call for more SD versus CFS comparisons (was: Re: [ck] Mainline plans)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

some results based on massing_intr.c by Satoru, can be found on
http://people.redhat.com/mingo/cfs-scheduler/tools/massive_intr.c

Runned several times like:
$ massing_intr 5 2 >> results-kernel-5.2
$ massing_intr 300 300 >> results-kernel-300.300

To calculate average and standard deviation:

$ original-awk -f awkscript results-file

awkscript file included.
(for debian users: apt-get install original-awk)

Here's the data, values and facts:

kernel                  run as  average stddev
======                  ======  ======= ======
2.6.22-rc4-ck1          5 2     34      0
2.6.22-rc4-ck1          5 2     22      0
2.6.22-rc4-ck1          5 2     24.6    0.219
2.6.22-rc4-ck1          5 2     31.4    0.219
2.6.22-rc4-ck1          5 2     40      0

2.6.22-rc4-cfs-v16      5 2     36      0
2.6.22-rc4-cfs-v16      5 2     30      0
2.6.22-rc4-cfs-v16      5 2     27.6    0.219
2.6.22-rc4-cfs-v16      5 2     29.6    0.219
2.6.22-rc4-cfs-v16      5 2     42      0

2.6.22-rc4-cfs-v16      300 300 126.427 0.289
2.6.22-rc4-cfs-v16      300 300 125.35  0.275
2.6.22-rc4-cfs-v16      300 300 127,797 0,028
2.6.22-rc4-cfs-v16      300 300 125,367 0,028
2.6.22-rc4-cfs-v16      300 300 125,213 0,024

2.6.22-rc4-ck1          300 300 125.413 0,028
2.6.22-rc4-ck1          300 300 125,34  0,027
2.6.22-rc4-ck1          300 300 124,69  0,027
2.6.22-rc4-ck1          300 300 125,093 0,017
2.6.22-rc4-ck1          300 300 125,597 0,028

* "run as" it's the parameters passed to the program massive_intr.

All the files and data can be found on
http://www.debianpt.org/~elmig/pool/kernel/20070611/

Just one note, the first time this test was run:
-cfs-v16 i got this values: 44, 23, 19, 16, 42;
-2.6.21-debian: 29, 25, 22, 16, 32;
-ck1: 37 37 37 37 37

The machine was a Sempron64 3.0 GHz.


I know that other people, who read lkml, also tested the same way, it
would be nice if they also post their data.

-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org

