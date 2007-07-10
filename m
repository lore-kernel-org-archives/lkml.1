Return-Path: <linux-kernel-owner+w=401wt.eu-S1760478AbXGJIwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760478AbXGJIwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbXGJIwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:52:36 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756184AbXGJIwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:52:35 -0400
Date: Tue, 10 Jul 2007 01:52:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefano Rivoir <s.rivoir@gts.it>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
Message-Id: <20070710015207.a46abde4.akpm@linux-foundation.org>
In-Reply-To: <4693327E.6000006@gts.it>
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org>
	<4693327E.6000006@gts.it>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 09:17:18 +0200 Stefano Rivoir <s.rivoir@gts.it> wrote:

> Linus Torvalds wrote:
> > It's out there now (or at least in the process of mirroring out - if you 
> > don't see everything, give it a bit of time).
> 
> Hi all.
> 
> 2.6.22 hangs at boot on my box. Here attached a original dmesg from 
> 2.6.21, and a copy of it where it stops on 2.6.22 (I can't attach the 
> original 2.6.22 dmesg because it's not logged to disk yet); it actually 
> stops right after 'init' launches.
> 
> Thinking it was something related to USB mass storage, I've disabled 
> (not in the attached .config) it but with no results.

If you have another Linux box on the LAN, please set up netconsole
(Documentation/networking/netconsole.txt) to gather the boot logs.

When the machine has stalled, see if you can get a task trace with
ALT-SYSRQ-t.  This will require CONFIG_MAGIC_SYSRQ=y and possibly setting
ignore_loglevel on the kernel boot command line.

Thanks.

(mad guesses: try the following on the boot command line: clock=pit,
noacpi, noapic)
