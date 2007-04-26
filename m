Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbXDZVZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbXDZVZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 17:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbXDZVZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 17:25:51 -0400
Received: from serverina.hacknight.org ([80.68.90.101]:4268 "EHLO
	serverina.hacknight.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbXDZVZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 17:25:50 -0400
X-Greylist: delayed 1909 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 17:25:50 EDT
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: v2.6.21-rt1
References: <20070205065636.GA1652@elte.hu> <20070426135730.GA2116@elte.hu>
From: Free Ekanayaka <free@64studio.com>
Organization: 64 Studio
Date: Thu, 26 Apr 2007 22:53:54 +0200
In-Reply-To: <20070426135730.GA2116@elte.hu> (Ingo Molnar's message of "Thu, 26 Apr 2007 15:57:30 +0200")
Message-ID: <87mz0u502l.fsf@64studio.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

|--==> Ingo Molnar writes:

  IM> i have released the v2.6.20-rt1 kernel, which can be downloaded from the 
  IM> usual place:

  IM>     http://redhat.com/~mingo/realtime-preempt/
 
  IM> more info about the -rt patchset can be found in the RT wiki:
 
  IM>     http://rt.wiki.kernel.org

  IM> This is a fixes-only release.

  IM> to build a 2.6.21-rt1 tree, the following patches should be applied:

  IM>   http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.tar.bz2
  IM>   http://redhat.com/~mingo/realtime-preempt/patch-2.6.21-rt1

I've tested the patch on a Pavillon zv5000 laptop (amd64) and
apparently the kernel still hangs when one of the script in the
initramfs [0] tries to run udevsettle.

Booting with noapic doesn't seem to help, and differently from the
2.6.21-rc6-rt0 release [1] this time the kernel won't boot even with
qemu.

Here's the config I used:

http://people.64studio.com/~free/config-2.6.21-rt1

Ciao,

Free

[0] http://people.64studio.com/~free/udev
[1] http://www.mail-archive.com/linux-rt-users@vger.kernel.org/msg00332.html
