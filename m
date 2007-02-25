Return-Path: <linux-kernel-owner+w=401wt.eu-S932962AbXBYI6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbXBYI6I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 03:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933681AbXBYI6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 03:58:08 -0500
Received: from il.qumranet.com ([82.166.9.18]:44054 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932962AbXBYI6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 03:58:07 -0500
Message-ID: <45E14F9D.3050502@qumranet.com>
Date: Sun, 25 Feb 2007 10:58:05 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: PIO port width on various archs?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm changing the kvm userspace interface to be more friendly to other 
archs.  One issue is the PIO port size.  x86 uses 16 bits to hold the 
port size (64K ports).  Is that an issue for other archs?

I guess I could change it to __u32, but it's better to know what various 
architectures actually require.

-- 
error compiling committee.c: too many arguments to function

