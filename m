Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZASRKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZASRKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbZASRJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:09:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52161 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200AbZASRJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:09:52 -0500
Date: Mon, 19 Jan 2009 15:09:22 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemtrace: kbuild failed to make the new header symlink...
Message-ID: <20090119170922.GD19302@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
	Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090119164029.GB19302@ghostprotocols.net> <20090119165926.GA5287@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119165926.GA5287@localhost>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 19, 2009 at 06:59:26PM +0200, Eduard - Gabriel Munteanu escreveu:
> On Mon, Jan 19, 2009 at 02:40:29PM -0200, Arnaldo Carvalho de Melo wrote:
> > Sam,
> > 
> > 	I just did a git pull on linux-2.6-tip, then, on a build
> > directory (make O=../build/blkftrace/) with a previous build a tree
> > cloned from Linus I got stuck with the messages below.
> > 
> > 	I could only get this to work after a make mrproper, thought I
> > could mention this so that perhaps this can get detected and time be
> > saved somehow.
> > 
> >   CC      arch/x86/mm/fault.o
> > /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:38:27: error: asm/kmemcheck.h: No such file or directory
> > /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c: In function ???do_page_fault???:
> > /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:614: error: implicit declaration of function ???kmemcheck_active???
> > /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:615: error: implicit declaration of function ???kmemcheck_hide???
> > /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:644: error: implicit declaration of function ???kmemcheck_fault???
> 
> Hi,
> 
> This looks like a kmemcheck, not kmemtrace, fault. Heh, but we already
> have 3 things with similar names: kmemcheck, kmemtrace and kmemleak. :)

Yeah, sorry for that, but the problem in the end, seems to be in kbuild,
not in any of those kmemFEATURES :)

Anyway, when in doubt, use Mr. Proper products and go on with life :-)

- Arnaldo
