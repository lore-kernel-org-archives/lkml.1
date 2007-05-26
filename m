Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbXEZOHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbXEZOHo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 10:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbXEZOHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 10:07:38 -0400
Received: from v6.netlin.pl ([62.121.136.6]:60381 "EHLO pointblue.com.pl"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbXEZOHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 10:07:37 -0400
From: Tommy Vercetti <vercetti@zlew.org>
To: Paolo Ornati <ornati@fastwebnet.it>
Subject: Re: 2.6.21.1 - 97% wait time on IDE operations
Date: Sat, 26 May 2007 16:07:49 +0200
User-Agent: KMail/1.9.3
Cc: linux-kernel@vger.kernel.org
References: <200705261505.38109@gj-laptop> <20070526155223.1bedba5a@localhost>
In-Reply-To: <20070526155223.1bedba5a@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705261607.49416@gj-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 May 2007 15:52, Paolo Ornati wrote:
> On Sat, 26 May 2007 15:05:38 +0200
> It means that the disk is slow and the CPU is fast... so while the disk
> is busy seeking and reading data the CPU has nothing to do but wait for
> it.
>
> Idle == CPU has nothing to do
> Waiting == CPU has nothing to do, but it will have as soon as the slow
> 	disk (or whatever) delivers data
mhm.

> Anyway 97% is quite high... what CPU / Hard Disk do you have?
Intel(R) Pentium(R) M processor 1400MHz
TOSHIBA MK8025GAS

> What kernel version?
2.6.21.1
> I/O scheduler? (cat /sys/block/DEVICE/queue/scheduler)
gj@puppet:~$ cat /sys/block/hda/queue/scheduler
noop anticipatory deadline [cfq]

> Filesystem?
reiser3
> And what time of "operations" are you doing?
apt-get install, vmware

-- 
Vercetti
