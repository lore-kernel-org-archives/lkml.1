Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbYJaW5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbYJaW5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 18:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYJaW5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 18:57:37 -0400
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1936 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYJaW5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 18:57:37 -0400
Message-ID: <490B8D5E.2050100@xs4all.nl>
Date: Fri, 31 Oct 2008 23:57:34 +0100
From: Hans de Bruin <bruinjm@xs4all.nl>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: 2.6.8-rc2 build problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.8-rc2 won't do a make (silent)oldconfig. To make sure i did not lose 
anything I recloned linux-2.6

commit 721d5dfe7e516954c501d5e9d0dfab379cf4241a

$ make O=/var/diskless/kernel/psion/ oldconfig
   GEN     /var/diskless/kernel/psion/Makefile
   HOSTCC  scripts/kconfig/zconf.tab.o
gcc: /var/diskless/kernel/linux-2.6/scripts/kconfig/zconf.tab.c: No such 
file or directory
gcc: no input files
make[2]: *** [scripts/kconfig/zconf.tab.o] Error 1
make[1]: *** [oldconfig] Error 2
make: *** [sub-make] Error 2


-- 
Hans
