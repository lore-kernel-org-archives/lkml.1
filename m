Return-Path: <linux-kernel-owner+w=401wt.eu-S1763057AbZAQXOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763057AbZAQXOS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 18:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762196AbZAQXNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 18:13:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39293 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760294AbZAQXNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 18:13:41 -0500
Date: Sat, 17 Jan 2009 18:42:25 +0100
From: Pavel Machek <pavel@suse.cz>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tvignaud@mandriva.com" <tvignaud@mandriva.com>
Subject: Re: [patch] x86, pat: fix reserve_memtype() for legacy 1MB range
Message-ID: <20090117174224.GA1409@ucw.cz>
References: <20090109223520.GC6472@linux-os.sc.intel.com> <4967D223.1090703@zytor.com> <20090109224804.GD6472@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109224804.GD6472@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-09 14:48:04, Suresh Siddha wrote:
> On Fri, Jan 09, 2009 at 02:39:31PM -0800, H. Peter Anvin wrote:
> > Suresh Siddha wrote:
> > >
> > > Here X is trying to map first 8KB of memory using /dev/mem. Existing
> > > code treats first 0-4KB of memory as non-RAM and 4KB-8KB as RAM. Recent
> > > code changes don't allow to map memory with different attributes
> > > at the same time.
> > >
> > 
> > Why was 0-4 KB marked as non-RAM?  It is most definitely RAM, and should
> > be WB.
> 
> While in reality it is RAM, we have CONFIG_STRICT_DEVMEM which doesn't allow
> apps to map RAM pages using /dev/mem. And to allow app's to map the
> legacy 0-4KB bios data page, we consider it as non-RAM.

Fix config_strict_devmem? Ram is ram, and we should not li for
strict_devmem benefit...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
