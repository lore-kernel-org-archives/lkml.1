Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbYJXUwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbYJXUwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 16:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbYJXUwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 16:52:41 -0400
Received: from waste.org ([66.93.16.53]:32785 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbYJXUwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 16:52:41 -0400
Subject: Bloatwatch 2.6.28-rc1: last_sysfs_file
From: Matt Mackall <mpm@selenic.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 15:51:54 -0500
Message-Id: <1224881514.3248.46.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-rc1 adds 4k for last_sysfs_file debug tracking. That's one hell
of a long sysfs path.

http://www.selenic.com/bloatwatch/?cmd=compare;v1=2.6.27;v2=2.6.28-rc1;part=/built-in/fs/sysfs

-- 
Mathematics is the supreme nostalgia of our time.

