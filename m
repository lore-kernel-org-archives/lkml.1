Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbZASXaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbZASXaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 18:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759038AbZASXaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 18:30:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48436 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784AbZASXaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 18:30:13 -0500
Date: Tue, 20 Jan 2009 00:29:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kmemtrace: kbuild failed to make the new header symlink...
Message-ID: <20090119232948.GA30353@elte.hu>
References: <20090119164029.GB19302@ghostprotocols.net> <20090119182825.GA11165@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090119182825.GA11165@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

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
> > /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c: In function ‘do_page_fault’:
> > /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:614: error: implicit declaration of function ‘kmemcheck_active’
> > /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:615: error: implicit declaration of function ‘kmemcheck_hide’
> > /home/acme_unencrypted/git/linux-2.6-tip/arch/x86/mm/fault.c:644: error: implicit declaration of function ‘kmemcheck_fault’
> > 
> 
> The problem is that kmemcheck.h is located in include/asm-x86/ which is wrong.

indeed - it was still on an older base - i just fixed that.

	Ingo
