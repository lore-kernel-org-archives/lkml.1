Return-Path: <linux-kernel-owner+w=401wt.eu-S1752057AbXCECWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbXCECWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbXCECWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:22:53 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:45821 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbXCECWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:22:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=upo4MaQnnCNhIOcHksVgElQTgPRaZuHtT1cK93h1oesV/t9oDbrJs5pizGC8LWjHDgLojEEI2mm0tAIrBJD/U7hoRCrVM1UzC0sDaLU2RnQ2wSos6rQ9hPX/ismShMIwqaKHLriq8F/D1evJ+CnJMPHht8I6xm921zFjyDx31ZI=
Message-ID: <a44ae5cd0703041822l777eb4adjea12cef99cf7d89c@mail.gmail.com>
Date: Sun, 4 Mar 2007 18:22:51 -0800
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc2-mm1 -- kernel/sched.c:3384: error: 'struct rq' has no member named 'in_nohz_recently'
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I ran "make oldconfig" and picked various options and then make hit:

  CC      kernel/sched.o
kernel/sched.c: In function 'trigger_load_balance':
kernel/sched.c:3384: error: 'struct rq' has no member named 'in_nohz_recently'
kernel/sched.c:3384: error: 'struct rq' has no member named 'idle_at_tick'
kernel/sched.c:3385: error: 'struct rq' has no member named 'in_nohz_recently'
kernel/sched.c:3387: error: 'nohz' undeclared (first use in this function)
kernel/sched.c:3387: error: (Each undeclared identifier is reported only once
kernel/sched.c:3387: error: for each function it appears in.)
kernel/sched.c:3404: warning: implicit declaration of function 'resched_cpu'
kernel/sched.c:3412: error: 'struct rq' has no member named 'idle_at_tick'
kernel/sched.c:3422: error: 'struct rq' has no member named 'idle_at_tick'
make[1]: *** [kernel/sched.o] Error 1

# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
