Return-Path: <linux-kernel-owner+w=401wt.eu-S964783AbXBYLJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783AbXBYLJM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 06:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752343AbXBYLJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 06:09:12 -0500
Received: from il.qumranet.com ([82.166.9.18]:40576 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbXBYLJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 06:09:11 -0500
Message-ID: <45E16E54.60503@qumranet.com>
Date: Sun, 25 Feb 2007 13:09:08 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] kvm-15 release
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The big news today is that live migration works with kvm (kvm-14 could 
do live migration, but only with -no-kvm).  See 
http://kvm.qumranet.com/kvmwiki/Migration for instructions.

Changes from kvm-14:
- live migration with kvm (Uri Lublin)
   - based on Anthony Liguori's qemu patches
- new userspace interface (work in progress)
- the usual random fixes

Note that if you use the modules from Linux 2.6.20, you need to use
kvm-12.  You can use kvm-15 with Linux 2.6.20, provided you use the
external module included in kvm-15.  API/ABI stability is planned for
Linux 2.6.21.

http://kvm.qumranet.com

-- 
error compiling committee.c: too many arguments to function

