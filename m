Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbZCOP3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbZCOP3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 11:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbZCOP3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 11:29:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:38453 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751369AbZCOP27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 11:28:59 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX18hYC1z9/8hrMghTqurT5sXjP2Dx1Yf2PIB8IFevT
	BeBpw7KHL+moiL
Message-ID: <49BD1EB7.6080109@fisher-privat.net>
Date: Sun, 15 Mar 2009 16:28:55 +0100
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: smart cache. ist is possible?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo all.
I found for my self how great is cache in linux. If read one file from
disk, so i don't need to do it second time, chace will do the job. It
speed up thing greatly. But i found it not working with realy big files.
Like i have 4GB RAM, so if i read a file like 4.6GB, cache won't work.
Is it possible to have some sort of smart cache wich will read for
exaplme 1GB from disk and other part from cache?

here is some simple test:
=====================cache not working==========================
dd if=dvd.iso of=/dev/null
9017680+0 Datensätze ein
9017680+0 Datensätze aus
4617052160 Bytes (4,6 GB) kopiert, 90,7817 s, *50,9 MB/s*

dd if=dvd.iso of=/dev/null
9017680+0 Datensätze ein
9017680+0 Datensätze aus
4617052160 Bytes (4,6 GB) kopiert, 90,7817 s, *50,9 MB/s*
===============================================================


=====================cache working============================
dd if=film.avi of=/dev/null
1432600+0 Datensätze ein
1432600+0 Datensätze aus
733491200 Bytes (733 MB) kopiert, 15,5108 s, *47,3 MB/s*

dd if=film.avi of=/dev/null
1432600+0 Datensätze ein
1432600+0 Datensätze aus
733491200 Bytes (733 MB) kopiert, 0,941367 s, *779 MB/s*
==============================================================
