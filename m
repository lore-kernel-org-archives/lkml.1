Return-Path: <linux-kernel-owner+w=401wt.eu-S1762632AbXGFB4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632AbXGFB4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 21:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757751AbXGFB4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 21:56:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757033AbXGFB4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 21:56:03 -0400
Date: Thu, 5 Jul 2007 21:55:58 -0400
From: Dave Jones <davej@redhat.com>
To: Bodo Eggert <7eggert@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: slow down printk during boot.
Message-ID: <20070706015558.GE31633@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bodo Eggert <7eggert@gmx.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>
References: <8DGUc-ER-37@gated-at.bofh.it> <E1I6cxX-0007Dj-Lo@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I6cxX-0007Dj-Lo@be1.lrz>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2007 at 03:50:11AM +0200, Bodo Eggert wrote:
 > Dave Jones <davej@redhat.com> wrote:
 > 
 > > This patch from Randy has proven quite useful from time to time,
 > > and has been in Fedora kernels for a while for that reason.
 > > I fixed up some checkpatch warnings, and rediffed it a bunch
 > > of times, Randy did the heavy lifting.
 > > 
 > > ---
 > > 
 > > This one delays each printk() during boot by a variable time
 > > (from kernel command line), while system_state == SYSTEM_BOOTING.
 > > Caveat:  it's not terribly SMP safe or SMP nice.
 > > Any ideas for improvements (esp. in the SMP area) are appreciated.
 > 
 > I just created a different patch, which replaces the panic with one that
 > does allow scrolling and reading the messages. Maybe that would be the
 > better approach ...

I've used the 'slow down the printk' patch in situations where we
haven't panic'd, but silently rebooted instantly or hung with
a black screen.

	Dave

-- 
http://www.codemonkey.org.uk
