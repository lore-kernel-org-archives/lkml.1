Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbYDKGsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbYDKGsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 02:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754212AbYDKGsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 02:48:03 -0400
Received: from mail.gmx.net ([213.165.64.20]:47320 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753329AbYDKGsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 02:48:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18OZzoP4D8OC9beYkBsRNu0VVB9XSITKlQ5DO/xNf
	PhxuWvL2tZQexP
Subject: latencytop kills volanomark throughput.  yawn?
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-Yhd3DMTU6YNOrVaRcJO6"
Date: Fri, 11 Apr 2008 08:47:56 +0200
Message-Id: <1207896476.16745.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Yhd3DMTU6YNOrVaRcJO6
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Greetings list,

The moral of this story is probably "don't do that", but...

While doing some scheduler testing recently, I ran volanomark, and
accidentally left latencytop running.  The results were decidedly
un-good, and the reason appears to be that MUCH time is spent crawling
over a list of (106 loaded) modules.

	-Mike

--=-Yhd3DMTU6YNOrVaRcJO6
Content-Disposition: attachment; filename=oreport-2.6.25-smp-latencytop
Content-Type: text/plain; name=oreport-2.6.25-smp-latencytop; charset=UTF-8
Content-Transfer-Encoding: 7bit

2.6.25-smp
ulimit -Sn = 1024


/usr/bin/java -server -Xmx64m -Dinstall.root=. -Dcatalina.home=. -cp .:lib/bootstrap.jar:lib/catalina.jar:lib/naming-common.jar:lib/naming-resources.jar:lib/servlet.jar:lib/servlets-common.jar:lib/servlets-default.jar:lib/volanochat-server.jar:lib/xerces.jar COM.volano.Main

VolanoChat(TM) Server Version 2.5.0.9
Copyright (C) 1996-2002 Volano LLC.  All rights reserved.
Loading server properties from "/root/vmark2.5.0.9/conf/properties.txt".
marge:8000 (127.0.0.2:8000) VolanoChatPro - unlimited connections.
ulimit -Sn = 1024


/usr/bin/java -server -Xmx64m -Dinstall.root=. -Dcatalina.home=. -cp .:lib/bootstrap.jar:lib/catalina.jar:lib/naming-common.jar:lib/naming-resources.jar:lib/servlet.jar:lib/servlets-common.jar:lib/servlets-default.jar:lib/volanochat-server.jar:lib/xerces.jar COM.volano.Mark -run -count 2500

VolanoMark(TM) Benchmark Version 2.5.0.9
Copyright (C) 1996-2002 Volano LLC.  All rights reserved.
Creating room number 1 ...
20 connections so far.
Creating room number 2 ...
40 connections so far.
Creating room number 3 ...
60 connections so far.
Creating room number 4 ...
80 connections so far.
Creating room number 5 ...
100 connections so far.
Creating room number 6 ...
120 connections so far.
Creating room number 7 ...
140 connections so far.
Creating room number 8 ...
160 connections so far.
Creating room number 9 ...
180 connections so far.
Creating room number 10 ...
200 connections so far.
Java heap:  4225 KB in use, 11968 KB available (35% in use).
Running the test ...
Test complete.

VolanoMark version = 2.5.0.9
Messages sent      = 500000
Messages received  = 9500000
Total messages     = 10000000
Elapsed time       = 256.251 seconds
Average throughput = 39024 messages per second
VolanoMark(TM) Benchmark Version 2.5.0.9
Copyright (C) 1996-2002 Volano LLC.  All rights reserved.
Creating room number 1 ...
20 connections so far.
Creating room number 2 ...
40 connections so far.
Creating room number 3 ...
60 connections so far.
Creating room number 4 ...
80 connections so far.
Creating room number 5 ...
100 connections so far.
Creating room number 6 ...
120 connections so far.
Creating room number 7 ...
140 connections so far.
Creating room number 8 ...
160 connections so far.
Creating room number 9 ...
180 connections so far.
Creating room number 10 ...
200 connections so far.
Java heap:  4055 KB in use, 11968 KB available (34% in use).
Running the test ...
Test complete.

VolanoMark version = 2.5.0.9
Messages sent      = 500000
Messages received  = 9500000
Total messages     = 10000000
Elapsed time       = 260.755 seconds
Average throughput = 38350 messages per second
VolanoMark(TM) Benchmark Version 2.5.0.9
Copyright (C) 1996-2002 Volano LLC.  All rights reserved.
Creating room number 1 ...
20 connections so far.
Creating room number 2 ...
40 connections so far.
Creating room number 3 ...
60 connections so far.
Creating room number 4 ...
80 connections so far.
Creating room number 5 ...
100 connections so far.
Creating room number 6 ...
120 connections so far.
Creating room number 7 ...
140 connections so far.
Creating room number 8 ...
160 connections so far.
Creating room number 9 ...
180 connections so far.
Creating room number 10 ...
200 connections so far.
Java heap:  4079 KB in use, 11968 KB available (34% in use).
Running the test ...
Test complete.

VolanoMark version = 2.5.0.9
Messages sent      = 500000
Messages received  = 9500000
Total messages     = 10000000
Elapsed time       = 257.859 seconds
Average throughput = 38781 messages per second
CPU: Core 2, speed 2400 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 100000
Samples on CPU 0
Samples on CPU 1
Samples on CPU 2
Samples on CPU 3
vma      samples  %        samples  %        samples  %        samples  %        symbol name
ffffffff80250ac3 7275309  75.2127  7484800  75.2938  7470398  75.2679  7496386  75.3165  __module_text_address
ffffffff80242f08 153617    1.5881  159017    1.5996  157306    1.5849  158765    1.5951  core_kernel_text
ffffffff80242f77 137870    1.4253  146199    1.4707  145779    1.4688  146526    1.4722  __kernel_text_address
ffffffff8040fa80 131667    1.3612  134133    1.3493  133196    1.3420  133695    1.3432  schedule

--=-Yhd3DMTU6YNOrVaRcJO6
Content-Disposition: attachment; filename=oreport-2.6.25-smp-no-latencytop
Content-Type: text/plain; name=oreport-2.6.25-smp-no-latencytop; charset=UTF-8
Content-Transfer-Encoding: 7bit

2.6.25-smp
ulimit -Sn = 1024


/usr/bin/java -server -Xmx64m -Dinstall.root=. -Dcatalina.home=. -cp .:lib/bootstrap.jar:lib/catalina.jar:lib/naming-common.jar:lib/naming-resources.jar:lib/servlet.jar:lib/servlets-common.jar:lib/servlets-default.jar:lib/volanochat-server.jar:lib/xerces.jar COM.volano.Main

VolanoChat(TM) Server Version 2.5.0.9
Copyright (C) 1996-2002 Volano LLC.  All rights reserved.
Loading server properties from "/root/vmark2.5.0.9/conf/properties.txt".
marge:8000 (127.0.0.2:8000) VolanoChatPro - unlimited connections.
Apache Tomcat/4.0.3
ulimit -Sn = 1024


/usr/bin/java -server -Xmx64m -Dinstall.root=. -Dcatalina.home=. -cp .:lib/bootstrap.jar:lib/catalina.jar:lib/naming-common.jar:lib/naming-resources.jar:lib/servlet.jar:lib/servlets-common.jar:lib/servlets-default.jar:lib/volanochat-server.jar:lib/xerces.jar COM.volano.Mark -run -count 2500

VolanoMark(TM) Benchmark Version 2.5.0.9
Copyright (C) 1996-2002 Volano LLC.  All rights reserved.
Creating room number 1 ...
20 connections so far.
Creating room number 2 ...
40 connections so far.
Creating room number 3 ...
60 connections so far.
Creating room number 4 ...
80 connections so far.
Creating room number 5 ...
100 connections so far.
Creating room number 6 ...
120 connections so far.
Creating room number 7 ...
140 connections so far.
Creating room number 8 ...
160 connections so far.
Creating room number 9 ...
180 connections so far.
Creating room number 10 ...
200 connections so far.
Java heap:  4103 KB in use, 11968 KB available (34% in use).
Running the test ...
Test complete.

VolanoMark version = 2.5.0.9
Messages sent      = 500000
Messages received  = 9500000
Total messages     = 10000000
Elapsed time       = 80.53 seconds
Average throughput = 124177 messages per second
VolanoMark(TM) Benchmark Version 2.5.0.9
Copyright (C) 1996-2002 Volano LLC.  All rights reserved.
Creating room number 1 ...
20 connections so far.
Creating room number 2 ...
40 connections so far.
Creating room number 3 ...
60 connections so far.
Creating room number 4 ...
80 connections so far.
Creating room number 5 ...
100 connections so far.
Creating room number 6 ...
120 connections so far.
Creating room number 7 ...
140 connections so far.
Creating room number 8 ...
160 connections so far.
Creating room number 9 ...
180 connections so far.
Creating room number 10 ...
200 connections so far.
Java heap:  4066 KB in use, 11968 KB available (34% in use).
Running the test ...
Test complete.

VolanoMark version = 2.5.0.9
Messages sent      = 500000
Messages received  = 9500000
Total messages     = 10000000
Elapsed time       = 82.893 seconds
Average throughput = 120637 messages per second
VolanoMark(TM) Benchmark Version 2.5.0.9
Copyright (C) 1996-2002 Volano LLC.  All rights reserved.
Creating room number 1 ...
20 connections so far.
Creating room number 2 ...
40 connections so far.
Creating room number 3 ...
60 connections so far.
Creating room number 4 ...
80 connections so far.
Creating room number 5 ...
100 connections so far.
Creating room number 6 ...
120 connections so far.
Creating room number 7 ...
140 connections so far.
Creating room number 8 ...
160 connections so far.
Creating room number 9 ...
180 connections so far.
Creating room number 10 ...
200 connections so far.
Java heap:  4066 KB in use, 11968 KB available (34% in use).
Running the test ...
Test complete.

VolanoMark version = 2.5.0.9
Messages sent      = 500000
Messages received  = 9500000
Total messages     = 10000000
Elapsed time       = 83.045 seconds
Average throughput = 120417 messages per second
CPU: Core 2, speed 2400 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 100000
Samples on CPU 0
Samples on CPU 1
Samples on CPU 2
Samples on CPU 3
vma      samples  %        samples  %        samples  %        samples  %        symbol name
ffffffff8040fa80 101885    7.3225  105675    7.3536  104738    7.3105  104360    7.2758  schedule
ffffffff8020a872 38079     2.7367  38675     2.6913  38259     2.6704  37778     2.6338  __switch_to
ffffffff803cd4a1 37283     2.6795  37872     2.6354  38264     2.6708  38416     2.6783  tcp_sendmsg
ffffffff803bce72 34238     2.4607  35386     2.4624  35458     2.4749  35369     2.4659  nf_iterate
ffffffff803d6dff 33708     2.4226  34382     2.3925  35210     2.4576  34770     2.4241  tcp_transmit_skb
ffffffff8022b435 32216     2.3154  32801     2.2825  32441     2.2643  32561     2.2701  task_rq_lock
ffffffff8041019b 30984     2.2268  32897     2.2892  33092     2.3098  33149     2.3111  thread_return
ffffffff80212710 28698     2.0625  29613     2.0607  29925     2.0887  30017     2.0927  native_read_tsc
ffffffff803a2c34 27350     1.9656  28071     1.9534  27624     1.9281  27601     1.9243  netif_rx
ffffffff803dcd35 27329     1.9641  27798     1.9344  28084     1.9602  28233     1.9683  tcp_v4_rcv
ffffffff802ffbe0 26391     1.8967  30879     2.1488  29893     2.0865  31739     2.2128  copy_user_generic_string
ffffffff803c6bb7 24902     1.7897  25270     1.7585  24637     1.7196  25099     1.7499  ip_queue_xmit
ffffffff8039dc47 24866     1.7871  26068     1.8140  25733     1.7961  25869     1.8035  skb_release_all
ffffffff8028db6b 24765     1.7799  25006     1.7401  25154     1.7557  25707     1.7922  fget_light
ffffffff80228378 23550     1.6925  24488     1.7040  23946     1.6714  24154     1.6840  __enqueue_entity
ffffffff803c9bd6 23270     1.6724  23490     1.6346  23264     1.6238  23375     1.6297  __inet_lookup_established
ffffffff8022f3a1 19656     1.4127  19080     1.3277  19152     1.3368  19208     1.3391  select_task_rq_fair
ffffffff803ce391 19498     1.4013  20477     1.4249  20394     1.4235  20409     1.4229  tcp_recvmsg
ffffffff803d1680 18634     1.3392  19414     1.3510  19538     1.3637  19178     1.3371  tcp_ack
ffffffff8023793d 18106     1.3013  18399     1.2803  18285     1.2763  18610     1.2975  local_bh_enable
ffffffff8020be00 17235     1.2387  17809     1.2393  17673     1.2335  17890     1.2473  system_call
ffffffff803a53f1 16076     1.1554  16560     1.1524  16230     1.1328  16464     1.1478  process_backlog
ffffffff803d5c26 15110     1.0860  16067     1.1180  15661     1.0931  15441     1.0765  tcp_rcv_established
ffffffff803d8892 15045     1.0813  15420     1.0730  15406     1.0753  15560     1.0848  __tcp_push_pending_frames
ffffffff80228683 14623     1.0510  14960     1.0410  14816     1.0341  14830     1.0339  hrtick_start_fair
ffffffff80212510 14567     1.0469  14818     1.0311  14922     1.0415  14979     1.0443  native_sched_clock

--=-Yhd3DMTU6YNOrVaRcJO6--

