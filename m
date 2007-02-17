Return-Path: <linux-kernel-owner+w=401wt.eu-S965336AbXBQQts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336AbXBQQts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 11:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965337AbXBQQts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 11:49:48 -0500
Received: from noname.neutralserver.com ([70.84.186.210]:18715 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965336AbXBQQts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 11:49:48 -0500
Date: Sat, 17 Feb 2007 18:49:21 +0200
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: linux-usb-devel@lists.sourceforge.net
Subject: OOM and USB, latest Linux 2.6
Message-ID: <20070217164920.GA31755@localdomain>
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

Is it possible that OOM isn't handled very well if say, my entire
file system structure is on a USB storage device?

I'm not an expert on this particular matter but I'm pretty sure 
that I noticed GFP_KERNEL allocation being done on the write-out 
path in the usb-storage kernel thread, leading to a deadlock 
during OOM.

Suggestions are welcomed...

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
