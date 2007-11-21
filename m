Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbXKUUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbXKUUyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 15:54:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751096AbXKUUyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 15:54:01 -0500
Received: from s1.yuriev.com ([208.76.223.68]:48196 "EHLO s1.yuriev.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbXKUUyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 15:54:01 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Nov 2007 15:54:01 EST
Date: Wed, 21 Nov 2007 15:57:53 -0500
From: alex-lists-linux-kernel@yuriev.com
To: linux-kernel@vger.kernel.org
Subject: Identifying a specific affected file on Ext3 on a top of raid0 of raid1s
Message-ID: <20071121205753.GA26864@s1.yuriev.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a rather nasty situation developing on one of the big 24x7 
production database servers. It seems that a batch of drives in one of the
servers started to fail. 

The file servers are ext3fs on a top of raid-0 over a pair of raid-1 mirrors, 
with each of raid-1 mirrors having two drives. The issue is that all four 
drives are developing errors. 

Is there a way to determine what files are affected if I know the LBA# of the
errors on individual drives?

It is running under 2.6.20.x series of kernels.

Alex

