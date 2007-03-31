Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986AbXCaGc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbXCaGc5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 02:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbXCaGc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 02:32:56 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:42168 "HELO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752897AbXCaGc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 02:32:56 -0400
Date: Sat, 31 Mar 2007 08:27:43 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.21-rc5-mm2 - compile error on x86-64
Message-ID: <20070331062743.GA26131@aitel.hist.no>
References: <20070326211627.c681af3b.akpm@linux-foundation.org> <20070329182020.GA9223@aitel.hist.no> <20070329142816.5d18d89f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070329142816.5d18d89f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Helge Hafting <helgehaf@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2007 at 02:28:16PM -0700, Andrew Morton wrote:
> On Thu, 29 Mar 2007 20:20:20 +0200
> Helge Hafting <helgehaf@aitel.hist.no> wrote:
> 
[...]
> yup, people will presumably work on fixing these things up after the
> feature hits mainline.
> 
> >   LD      init/built-in.o
> >   LD      .tmp_vmlinux1
> > fs/built-in.o: In function `proc_root_init':
> > /usr/src/linux/fs/proc/root.c:83: undefined reference to `proc_sys_init'
> 
> Ah.  I assume you have CONFIG_SYSCTL=y, CONFIG_PROC_SYSCTL=n?

Correct. I seem to remember that the latter is considered 
"deprecated, but some programs may still depend on it".  So I disabled it to 
see what broke.  udev complained about the missing /proc/sys/kernel/hotplug,
but was happy to use /sys/kernel/uevent_helper instead.  I didn't
notice other problems, so I left things like that.

Helge Hafting
