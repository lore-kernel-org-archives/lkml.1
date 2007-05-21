Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbXEULqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbXEULqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 07:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXEULq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 07:46:26 -0400
Received: from a.relay.invitel.net ([62.77.203.3]:60177 "EHLO
	a.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXEULqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 07:46:25 -0400
X-Greylist: delayed 1190 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2007 07:46:25 EDT
Date: Mon, 21 May 2007 13:26:30 +0200
From: =?iso-8859-1?B?R+Fib3IgTOlu4XJ0?= <lgb@lgb.hu>
To: linux-kernel@vger.kernel.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Message-ID: <20070521112630.GB15684@vega.lgb.hu>
Reply-To: lgb@lgb.hu
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr> <20070520205500.GJ22452@vanheusden.com> <200705202314.57758.ak@suse.de> <20070520212036.GL22452@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070520212036.GL22452@vanheusden.com>
X-Operating-System: vega Linux 2.6.20-15-generic i686
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 20, 2007 at 11:20:36PM +0200, Folkert van Heusden wrote:
> > > +	switch(sig) {
> > > +	case SIGQUIT: 
> > > +	case SIGILL: 
> > > +	case SIGTRAP:
> > > +	case SIGABRT: 
> > > +	case SIGBUS: 
> > > +	case SIGFPE:
> > > +	case SIGSEGV: 
> > > +	case SIGXCPU: 
> > > +	case SIGXFSZ:
> > > +	case SIGSYS: 
> > > +	case SIGSTKFLT:
> > 
> > Unconditional? That's definitely a very bad idea. If anything only unhandled
> > signals should be printed this way because some programs use them internally. 
> 
> Use these signals internally? Afaik these are fatal, stopping the
> process. So using them internally would be a little tricky.

For example mplayer uses SIGSEGV: it does not check ALL of the possible
error situations, in case of SIGSEGV (a bad stream etc) it quickly
reinit itself from the last position. It's much better in performance (well
sure for a stream without error, or only few of them) than to check all of
the possible problems. Nowdays it may not a problem to check everything but
it WAS when MPlayer born (much slower CPUs). But some signals are also
useful for emulation etc (eg in my own DOS emulator some years ago ....).

-- 
- Gábor
