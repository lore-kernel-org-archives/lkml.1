Return-Path: <linux-kernel-owner+w=401wt.eu-S1753672AbZIRGxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbZIRGxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbZIRGxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:53:00 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:54141 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560AbZIRGw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YFtE/mEbqaAz6QQTTQ94jLr2WTlGoqRfghOH74StalBaZK2EtpgPGIs3JqDH/SOb2G
         HdtYU51xvqUfL3RnMQLegoK8/sz++hijMcYEthxMeDKpwHSfJ7fIfqXXDnPVAX3Y4zwS
         E/7SJU2DsOEbcs57sJerUlBNr5KczCPa5Cxcs=
MIME-Version: 1.0
Date: Fri, 18 Sep 2009 08:53:03 +0200
Message-ID: <dda529d0909172353u6ec2c59ele6467617078f726d@mail.gmail.com>
Subject: suspend a thread with an another thread
From: maxime louvel <m.louvel@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI all,

I'm doing a phd related to QoS and resources management within
distributed systems.
I would like to affect a CPU budget to my applications, one
application being a thread.

As I would like to experiment quickly my ideas in order to test them,
I wanted to use a little trick :
instead of modifying the linux scheduler (which I guess will take me a
lot of time because I'm not familiar with it) I tried to use a "super
thread".

My try was that this "super thread" with higher priority is suspending
the other threads if they overcome their cpu budget.
I thought of something like activate an application thread, make the
super thread sleep for X time (cpu budget) and then wake up and
suspend the application thread until next time.

However I haven't been able to do that because I've read (and test
myself :) ) that :
- it is not possible to suspend a thread by an another thread (I don't
think I can use the pthread_cond facilities)
- as threads within a process share the signals and signal handlers I
can't send a signal (like SIGUSR1 or SIGSTOP) to a specific thread.
Correct me if I'm wrong

Is there a way I can do what I want ?

Or should I start by looking at how to modify the linux scheduler ?

thanks a lot,

Maxim

--
Maxime Louvel
+33 6 85 91 05 30
3 rue charreton
38000 Grenoble
France
