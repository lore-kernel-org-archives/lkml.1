Return-Path: <linux-kernel-owner+w=401wt.eu-S1751908AbXBRTXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908AbXBRTXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 14:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXBRTXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 14:23:09 -0500
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:38031 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751908AbXBRTXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 14:23:09 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Feb 2007 14:23:08 EST
X-YMail-OSG: XsJAcX0VM1lgxbU8zrhjMl9WTCtznpP93IgHaadotjdV7CCFbc479ZuNLXi_0y5Bl9.5VfrzpOlolf.bIK5bjFxDMjlNyokfMoLpVd1GaKHTuFI1UhPQzZk6qFZpX2WYVYcXhEiR
Message-ID: <45D8A609.2000806@smithhikers.net>
Date: Sun, 18 Feb 2007 13:16:25 -0600
From: Arthur Smith <asmith@smithhikers.net>
User-Agent: Thunderbird 1.5.0.9 (X11/20061223)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Partial Oops in 2.6.20?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
 I found this this morning on an AMD X2 based system that was unresponsive:

<....this part of the oops was lost off of the top of the screen, then>
ds: 007b es:007b ss:0068
Process events/1 (pid: 7, ti=f7c48000 task=f7d31560 task.ti=f7c48000)
Stack: 00000000 00000000 0000002c f7d1dc18 00000022 f7d1dc18 0000002c f7d1dc00
       00000000 c014bfbf 00000000 00000000 f7d28240 f7d2cde4 f7d2cdc0 f7d28240
       00000202 c1710380 c014d12a 00000000 00000000 c1710384 c17fe240 c01263ca
Call Trace:
[<c014bfbf>] drain_array+0x92/0xbd
[<c014d12a>] cache_reap+0x8e/0x113
[<c01263ca>] run_workqueue+0x85/0x125
[<c014d09c>] cache_reap+0x0/0x113
[<c0126ab8>] worker_thread+0xf9/0x124
[<c0114d22>] default_wake_function+0x0/0xc
[<c01269bf>] worker_thread+0x0/0x124
[<c012906d>] kthread+0xb2/0xdd
[<c0128fbb>] kthread+0x0/0xdd
[<c01036fb>] kernel_thread_helper+0x7/0x10
=======================
Code: 05 03 15 20 d2 4f c0 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 84 c0 78 04 0f 0b eb
<???..4> 24 28 8b 16 8b 7c 85 34 8b 46 04 <89> 42 04 89 10 2b 4e 0c c7 06 00 01 10 00 c7 4?

EIP: [<c014be9b>] free_block+0x5f/0xf1 SS:ESP 0068:f7c48f0c
<6>note: events1/[7] exited with preempt_count 1
<a few IPTables log messages?>
I copied this from a picture I took of the screen. I'm not sure there is enough there to be of any use.
It looks like the system was recording a tv show from a BT878 card at the time, using mencoder. Everything
is compiled into the kernel, no modules. I haven't seen Oops prior to this on this system. If this
is of any use, let me know and I can provide more details on the system - or anything else that might help.
  Thanks,
    Art Smith

