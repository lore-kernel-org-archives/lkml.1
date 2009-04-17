Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZDQEfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZDQEfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 00:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751044AbZDQEfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 00:35:32 -0400
Received: from main.gmane.org ([80.91.229.2]:55640 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbZDQEfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 00:35:31 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockrwd@gmail.com>
Subject: Barriers on LVM?
Date: Thu, 16 Apr 2009 22:35:08 -0600
Message-ID: <49E806FC.80000@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: dm-devel@redhat.com
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought somebody mentioned that LVM now had barrier support for 
single-disk configurations in 2.6.29, but my dmesg seems to say 
otherwise. This is essentially a default Fedora disk layout with root 
and swap partitions inside an LVM on a single SATA drive with 2.6.29.1:

EXT4-fs: barriers enabled

...

JBD: barrier-based sync failed on dm-0:8 - disabling barriers

Is proper LVM barrier support coming any time soon? It seems a bit 
brutal that the default disk layout on many systems (and almost all 
Fedora ones, which will default to ext4 in Fedora 11) can't support 
whatever data integrity needs ext4 is using them for..

