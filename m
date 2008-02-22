Return-Path: <linux-kernel-owner+w=401wt.eu-S933194AbYBVXIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbYBVXIu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 18:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758159AbYBVXIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 18:08:40 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:48888 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbYBVXIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 18:08:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iudWDumlljII084sYrsHMW1s/Uw+CAbIvsmVkVJrGcVQ7wEwh9avW0JfUxlL3KDRxaMufIn/KRar34dQIqX/q8YfBVVazB6brlL4HE9OCIp9nC25zx8BTCGItqDY00ReN0s5gzdnjTUrruT049PSrz8X0OJFrwTW7cswkIt80Dw=
Message-ID: <8abd1bfd0802221508i373d37e7hd6ad7702bde25330@mail.gmail.com>
Date: Fri, 22 Feb 2008 18:08:34 -0500
From: "Stephen Oberholtzer" <oliverklozoff@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: How to diagnose a process stuck in D state?
Cc: oliverklozoff@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First off: I'm not subscribed to the list (I don't think I could
handle the volume), so please make sure you CC me if you reply.

I run an application on one of my machines; it often hangs, with the
process stuck D state.  When this happens, the process sticks around
until I reboot the machine.

I have tried the following to start diagnosing the problem:

* Running 'ps -axl' shows "-" in the wchan column.
* The contents of /proc/pid/wchan say "_stext".
* 'strace -p pid' says "Process pid attached - interrupt to quit" and
stops responding.  Sending SIGINT and SIGTERM have no effect on the
strace process, although kill -11 (SIGSEGV, my personal favorite) does
work.

This is very confusing.  I would greatly appreciate it if someone
could tell me how a process can enter D state without being in a
syscall, and what I can do to start tracking down the cause.

(By the way: This is on amd64, 2.6.23. I'm updating to 2.6.24.2 right
now, on the off chance that whatever was causing the problem has been
fixed.)

-- 
-- Stevie-O
Real programmers use COPY CON PROGRAM.EXE
