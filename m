Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbXCSMnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbXCSMnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 08:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbXCSMnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 08:43:15 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:4571 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbXCSMnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 08:43:14 -0400
X-Greylist: delayed 1121 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Mar 2007 08:43:14 EDT
Message-ID: <45FE80FD.9090109@linux-kernel.at>
Date: Mon, 19 Mar 2007 13:24:29 +0100
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: axp question 'bout uname voodoo
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.399, required 5, ALL_TRUSTED -1.80, BAYES_00 -2.60)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

We have a discussion on alpha mailinglist at the moment, because of 
uname -mpi.

AFAIK, uname -m should do some glibc call, which calls kernel, right?

However, I have two machines:

AS1000A:
[root@tyskie ~]# uname -mpi && cat /proc/cpuinfo | grep model
alpha alpha alpha
cpu model               : EV56

DS10:
[root@gosa ~]# uname -mpi && cat /proc/cpuinfo |grep model
alpha alpha alpha
cpu model               : EV67

Shouldn't uname rport alphaev67 and alphaev56? Maybe it's just a .config 
problem. Maybe the kernel needs to be compiled for the different 
sub-arches!?

Any help would be great.

Thx,
  Oliver

