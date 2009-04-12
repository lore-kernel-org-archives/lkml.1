Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbZDLP3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbZDLP3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 11:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754415AbZDLP3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 11:29:14 -0400
Received: from mail001.aei.ca ([206.123.6.130]:55406 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbZDLP3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 11:29:13 -0400
From: Ed Tomlinson <edt@aei.ca>
To: linux-kernel@vger.kernel.org
Subject: How movable is zone movable?
Date: Sun, 12 Apr 2009 11:29:09 -0400
User-Agent: KMail/1.11.1 (Linux/2.6.30-rc1-crc; KDE/4.2.1; x86_64; ; )
Cc: mel@csn.ul.ie, Nick Piggin <npiggin@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904121129.09851.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

How dependable should zone movable be?  After a boot kvm is able to get enough hugepages to 
back the session.  After a day or two it becomes a lot less predictable.  Sometimes it will swap out for 30 seconds
and then succeed other times it will fail.  Interestingly, it sometimes works if I cancel the kvm session after
it tells me it cannot allocate the hugepages and immediatly restart.  It there some way to determine what
is not respecting zone moveable?  Or is zone moveable just a suggestion and not expected to really be 
moveable?

I have the following set in sysctl.conf

# huge_pages with movablecore set to 3G
kernel.shmmax = 8589934592
vm.nr_hugepages = 128
vm.nr_overcommit_hugepages = 1408
vm.hugepages_treat_as_movable = 1
vm.hugetlb_shm_group = 1005

This is with any recient kernel release (2.6.28 and later)

Thanks,
Ed Tomlinson
