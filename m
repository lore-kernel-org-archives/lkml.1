Return-Path: <linux-kernel-owner+w=401wt.eu-S1760756AbXHESEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756AbXHESEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 14:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbXHESEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 14:04:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38551 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbXHESEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 14:04:24 -0400
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
From: Arjan van de Ven <arjan@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
In-Reply-To: <20070805141708.GB25753@lazybastard.org>
References: <alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
	 <46B4C0A8.1000902@garzik.org> <20070804191205.GA24723@lazybastard.org>
	 <20070804192130.GA25346@elte.hu>
	 <20070804211156.5f600d80@the-village.bc.nu> <20070804202830.GA4538@elte.hu>
	 <20070804210351.GA9784@elte.hu> <20070804225121.5c7b66e0@the-village.bc.nu>
	 <20070805072141.GA4414@elte.hu> <20070805085354.GC6002@1wt.eu>
	 <20070805141708.GB25753@lazybastard.org>
Content-Type: text/plain; charset=UTF-8
Organization: Intel International BV
Date: Sun, 05 Aug 2007 11:02:33 -0700
Message-Id: <1186336953.2777.17.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-05 at 16:17 +0200, Jörn Engel wrote:
> On Sun, 5 August 2007 10:53:54 +0200, Willy Tarreau wrote:
> > On Sun, Aug 05, 2007 at 09:21:41AM +0200, Ingo Molnar wrote:
> > > 
> > > btw., Mutt does not go boom, i use it myself. It works just fine and 
> > > notices new mails even on a noatime,nodiratime filesystem.
> > 
> > IIRC, atime is used by mailers and by the shell to detect that new
> > mail has arrived and report it only once if there are several intances
> > watching the same mbox.
> > 
> > I too use mutt and noatime,nodiratime everywhere (same 10 year-old
> > thinko), and the only side effect is that when I have a new mail,
> > it is reported in all of my xterms until I read it, clearly something
> > I can live with (and sometimes it's even desirable).
> > 
> > In fact, mutt is pretty good at this. It updates atime and ctime itself
> > as soon as it opens the mbox, so the shell is happy and only reports
> > "you have mail" afterwards.
> 
> For me mutt fails to recognize new mail.  And the difference might be
> this:

but does it work with relatime ?


