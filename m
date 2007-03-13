Return-Path: <linux-kernel-owner+w=401wt.eu-S1030781AbXCMQda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030781AbXCMQda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030791AbXCMQda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:33:30 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:40280 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030782AbXCMQd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:33:29 -0400
Date: Tue, 13 Mar 2007 18:33:20 +0200
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: thread stacks and strict vm overcommit accounting
Message-ID: <20070313163320.GA28104@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-PopBeforeSMTPSenders: da-x@monatomic.org
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This question is relevent to 2.6.20.

I noticed that if the RSS for the stack size is say, 8MB, running
a single-threaded process doesn't incur an increase of 8MB to
Committed_AS (/proc/meminfo).

However, on multi-threaded apps linked with pthread (on Debian
Etch with 2.6.20 vanilla x86_64), every thread will incur the
the specified maximum stack size RSS (assuming that you use
the default attr). In other words, it appears that vm accounting
works differently in that case.

Is this the intended behaviour?

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
