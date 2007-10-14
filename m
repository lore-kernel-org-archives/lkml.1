Return-Path: <linux-kernel-owner+w=401wt.eu-S1762028AbXJNTfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762028AbXJNTfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 15:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754514AbXJNTe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 15:34:57 -0400
Received: from lucidpixels.com ([75.144.35.66]:57250 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbXJNTe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 15:34:56 -0400
Date: Sun, 14 Oct 2007 15:34:55 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
cc: apiszcz@solarrain.com
Subject: In response to kernel compression e-mail a few months ago.
Message-ID: <Pine.LNX.4.64.0710141533080.3935@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It turns out the one I did not test, was actually the best:

Used: 7z -mx=9 a linux-2.6.16.17.tar.7z linux-2.6.16.17.tar

$ du -sk * | sort -n
32392 linux-2.6.16.17.tar.7z
33520 linux-2.6.16.17.tar.lzma
33760 linux-2.6.16.17.tar.rar
38064 linux-2.6.16.17.tar.rz
39472 linux-2.6.16.17.tar.szip
39520 linux-2.6.16.17.tar.bz
39936 linux-2.6.16.17.tar.bz2
40000 linux-2.6.16.17.tar.bicom
40656 linux-2.6.16.17.tar.sit
47664 linux-2.6.16.17.tar.lha
49968 linux-2.6.16.17.tar.dzip
50000 linux-2.6.16.17.tar.gz
51344 linux-2.6.16.17.tar.arj
57552 linux-2.6.16.17.tar.lzo
57984 linux-2.6.16.17.tar.F
81136 linux-2.6.16.17.tar.Z
94544 linux-2.6.16.17.tar.zoo
101216 linux-2.6.16.17.tar.arc
228608 linux-2.6.16.17.tar

$ du -sh * | sort -n
32M linux-2.6.16.17.tar.7z
33M linux-2.6.16.17.tar.lzma
33M linux-2.6.16.17.tar.rar
37M linux-2.6.16.17.tar.rz
39M linux-2.6.16.17.tar.bicom
39M linux-2.6.16.17.tar.bz
39M linux-2.6.16.17.tar.bz2
39M linux-2.6.16.17.tar.szip
40M linux-2.6.16.17.tar.sit
47M linux-2.6.16.17.tar.lha
49M linux-2.6.16.17.tar.dzip
49M linux-2.6.16.17.tar.gz
50M linux-2.6.16.17.tar.arj
56M linux-2.6.16.17.tar.lzo
57M linux-2.6.16.17.tar.F
79M linux-2.6.16.17.tar.Z
92M linux-2.6.16.17.tar.zoo
99M linux-2.6.16.17.tar.arc
223M linux-2.6.16.17.tar



