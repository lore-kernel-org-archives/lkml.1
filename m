Return-Path: <linux-kernel-owner+w=401wt.eu-S1759157AbZDXKLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157AbZDXKLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 06:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbZDXKLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 06:11:00 -0400
Received: from mx44.mail.ru ([94.100.176.58]:53973 "EHLO mx44.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbZDXKLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 06:11:00 -0400
X-Greylist: delayed 521 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Apr 2009 06:10:59 EDT
From: Rutkov Denis <dendron2000@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: High kernel CPU usage when copying files
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: 194.226.199.147 via proxy [194.226.199.226]
Date: Fri, 24 Apr 2009 14:01:19 +0400
X-Mru-Data: 14358:0:1:0:107:0
Reply-To: Rutkov Denis <dendron2000@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1LxIDf-0004qD-00.dendron2000-mail-ru@f159.mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear linux kernel hackers, I need help hunting a very annoying bug. 

I'm using Xubuntu 9.04 (kernel 2.6.28-11-42) on a P4@2.0Ghz PC with 512MB RAM and two IDE drives (ext4). 

Whenever I copy files I got very high CPU usage from kernel. I tested this with ext3, ext4 and fat32 file systems. To trace the problem I installed oprofile and debug kernel image. I ran the profiler during file copying and saw that there are many calls to copy_to_user_ll and copy_from_user_ll functions. So I have two questions:

1. Is this normal I get so many of those function calls?

2. What can I do to further trace this bug?
