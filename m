Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbYETS1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbYETS1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 14:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbYETS0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 14:26:50 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:6326 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477AbYETS0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 14:26:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Tyr1ihQJc4VaUQc/oBKSmgaHsPtofqEwN7yMTWq3783KKzhls3U/8LxLlOZXqYoRgwQmfuATqGQSWpNlYvqQupp2QVKo26iU5qBwzmnbJNyAALF2tEeAOUOwvMZAqpCYcSDkvu6STeijTl3aYa3rdqFedcF9fRJLl1sfE7/OsXo=
Message-ID: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
Date: Tue, 20 May 2008 11:26:47 -0700
From: mark <markkicks@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: fork: Resource temporarily unavailable / cant start new threads
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I upgraded to 2.6.25.3-18.fc9.x86_64 fedora core 9, now I get this
error when I try to login to the box, kill a pr start a python app, or
do anything on a regular basis.

fork: Resource temporarily unavailable

I have over 10GB RAM free, and zero swap spaced used. The box is a
dual quad core Intel Xeon 5405 with 16GB RAM.

There is no error message in /var/log/messages or dmesg ...
how do I identify the problem?
thanks!

uname -a
Linux XXX 2.6.25.3-18.fc9.x86_64 #1 SMP Tue May 13 04:54:47 EDT 2008
x86_64 x86_64 x86_64 GNU/Linux


free -m
            total       used       free     shared    buffers     cached
Mem:         16086       3189      12896          0         42        666
-/+ buffers/cache:       2481      13605
Swap:         1983          0       1983


have only 505 processes running
ps aux | wc -l
505


uptime
 11:24:15 up 39 min,  1 user,  load average: 3.54, 3.47, 2.87

ulimit -a
core file size          (blocks, -c) 0
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 137216
max locked memory       (kbytes, -l) 32
max memory size         (kbytes, -m) unlimited
open files                      (-n) 32768
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 10240
cpu time               (seconds, -t) unlimited
max user processes              (-u) 1024
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
