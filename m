Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbXJCMCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbXJCMCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 08:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbXJCMCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 08:02:46 -0400
Received: from relay1.mail.vrmd.de ([81.28.232.18]:48756 "EHLO
	relay1.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbXJCMCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 08:02:45 -0400
X-Greylist: delayed 8487 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 08:02:45 EDT
Date: Wed, 3 Oct 2007 09:40:10 +0000
From: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
To: Anders Bostr?m <anders@bostrom.dyndns.org>
Cc: linux-kernel@vger.kernel.org, arjan@linux.intel.com, akpm@osdl.org,
       torvalds@osdl.org
Subject: Re: PROBLEM: high load average when idle
Message-ID: <20071003094010.GA635@ds20.borg.net>
Reply-To: dl8bcu@dl8bcu.de
Mail-Followup-To: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>,
	Anders Bostr?m <anders@bostrom.dyndns.org>,
	linux-kernel@vger.kernel.org, arjan@linux.intel.com, akpm@osdl.org,
	torvalds@osdl.org
References: <20071002.233731.119908363.anders@bostrom.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002.233731.119908363.anders@bostrom.dyndns.org>
User-Agent: Mutt/1.4.2.3i
X-Relay-User: dl8bcu@dl8bcu.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 11:37:31PM +0200, Anders Bostr?m wrote:
> Hi!
> 
> My computer suffers from high load average when the system is idle,
> introduced by commit 44d306e1508fef6fa7a6eb15a1aba86ef68389a6 .

Another datapoint: I observe a similar effect on both of my alphas:

top - 09:30:43 up 13 min, 18 users,  load average: 0.65, 0.64, 0.44
Tasks:  76 total,   1 running,  75 sleeping,   0 stopped,   0 zombie
Cpu(s):  0.1% us,  0.5% sy,  0.0% ni, 99.1% id,  0.2% wa,  0.1% hi,  0.0% si
Mem:   2067792k total,    55792k used,  2012000k free,     4160k buffers
Swap:  1048560k total,        0k used,  1048560k free,    18752k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  637 root      15   0  2904 1552 1192 R    1  0.1   0:01.35 top
  556 root      15   0  2008  528  432 S    0  0.0   0:00.01 gpm
    1 root      15   0  1960  800  680 S    0  0.0   0:01.43 init
    2 root      10  -5     0    0    0 S    0  0.0   0:00.00 kthreadd
    3 root      RT  -5     0    0    0 S    0  0.0   0:00.00 migration/0
    4 root      34  19     0    0    0 S    0  0.0   0:00.00 ksoftirqd/0
    5 root      RT  -5     0    0    0 S    0  0.0   0:00.00 watchdog/0
    6 root      RT  -5     0    0    0 S    0  0.0   0:00.00 migration/1
    7 root      34  19     0    0    0 S    0  0.0   0:00.00 ksoftirqd/1

This is the dual-ev6 one, currently 2.6.22-rc5. 

I didn't bother to do any investigation, yet ;-)


> This fixes the problem:

I'll check this evening.

Bye,
Thorsten


-- 
| Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
| Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
| Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
