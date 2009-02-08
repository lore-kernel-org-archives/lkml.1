Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZBHXeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZBHXeR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 18:34:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZBHXeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 18:34:06 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:39347 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbZBHXeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 18:34:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=joBcaQDwfnvcbOIC8jIbdXdafvmhIezo/y8VdBvvyOaBKjOnNBcN+Y5m8XjjehX93C
         x+JbDn7MaK17ZuERMuz0UFMJMFvf8JcOwzk5DWiJURmgKTCNtsgqwuhkfeVwd6ej2Kll
         lqDUwUryJVPkSg7uTITa5m7EV0qdqMuQKLEIg=
From: Simon Hafner <freakguard@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: SysRq shows help only
Date: Mon, 9 Feb 2009 00:35:00 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.28-ARCH; KDE/4.2.0; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902090035.00858.hafnersimon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello guys

I've got a wierd problem with my SysRq. Some data:
Kernel: 2.6.28-ARCH
Hardware: T61p

The Problem:
% cat /proc/sys/kernel/sysrq
1

echo "s" > /proc/sysrq-trigger
=>
SysRq : Emergency Sync
Emergency Sync complete

Pressing Sysrq + s
=>
SysRq : HELP : loglevel0-8 reBoot Crashdump tErm Full kIll saK aLlcpus showMem 
Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount shoW-
blocked-tasks
The help message shows up on any keypress.

Please CC

Greetings
FreakGuard
