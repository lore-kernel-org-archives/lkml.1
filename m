Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbYBXH6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbYBXH6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 02:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYBXH6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 02:58:11 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:46124 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbYBXH6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 02:58:10 -0500
Date: Sun, 24 Feb 2008 08:58:21 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: Reducing debuginfo size by removing unneeded includes
Message-ID: <20080224075821.GA7781@uranus.ravnborg.org>
References: <20080207230304.GA4352@ghostprotocols.net> <p73ir0mxvby.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73ir0mxvby.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi.

On Mon, Feb 18, 2008 at 02:12:01PM +0100, Andi Kleen wrote:
> Arnaldo Carvalho de Melo <acme@redhat.com> writes:
> >
> > [acme@doppio net-2.6]$ l /tmp/sys_ia32.o.before /tmp/sys_ia32.o.after
> > -rw-rw-r-- 1 acme acme 185240 2008-02-06 19:19 /tmp/sys_ia32.o.after
> > -rw-rw-r-- 1 acme acme 248328 2008-02-06 19:00 /tmp/sys_ia32.o.before
> >
> > 	Almost 64KB only on this object file!
> 
> Just FYI, newer gcc does this in theory automatically when you specify 
> 
> -feliminate-unused-debug-types -feliminate-unused-debug-symbols
google did not turn up anything useful.
Do you have a poiter to where these are described?


> There is also -feliminate-dwarf2-dups, but it seems to even increase
> obj dir size. Also -feliminate-dwarf2-dups seems to generate a lot of 

Google only turned up a patch from Mark Mitchell removing this
in ~2001 timeframe.
So again a pointer would be nice.

I use FC8:
gcc --version
gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)

So this is far behind trunk that you use - but I have not had any
real incentive to upgrade.

I would like to have a remote understanding of the options before
enabling them.

	Sam
