Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXAWUHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXAWUHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 15:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965486AbXAWUHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 15:07:39 -0500
Received: from aa011msr.fastwebnet.it ([85.18.95.71]:60068 "EHLO
	aa011msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965485AbXAWUHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 15:07:38 -0500
Date: Tue, 23 Jan 2007 21:07:35 +0100
From: Mattia Dongili <malattia@linux.it>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alessandro Di Marco <dmr@gmx.it>, linux-kernel@vger.kernel.org,
       vojtech@suse.cz
Subject: Re: [ANNOUNCE] System Inactivity Monitor v1.0
Message-ID: <20070123200735.GD9219@inferi.kami.home>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Alessandro Di Marco <dmr@gmx.it>, linux-kernel@vger.kernel.org,
	vojtech@suse.cz
References: <877ivkrv5s.fsf@gmx.it> <20070119101103.GA5730@ucw.cz> <877ivfi60i.fsf@gmx.it> <20070123094114.GE6033@ucw.cz> <87wt3dhlte.fsf@gmx.it> <20070123163442.GA18662@elf.ucw.cz> <20070123190107.GB9219@inferi.kami.home> <20070123190257.GF18662@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070123190257.GF18662@elf.ucw.cz>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.20-rc2-mm1-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 23, 2007 at 08:02:57PM +0100, Pavel Machek wrote:
> On Tue 2007-01-23 20:01:07, Mattia Dongili wrote:
> > On Tue, Jan 23, 2007 at 05:34:42PM +0100, Pavel Machek wrote:
> > [...]
> > > > Do you believe it could be a user-space daemon or what?
> > > 
> > > Yes, what prevents userspace daemon watching /dev/input/event* to
> > > provide this functionality?
> > 
> > hmmm... EVIOCGRAB for example? the synaptics Xorg driver is using
> > it, maybe others too?
> > I don't want to start a new discussion about it, just provide an answer
> > to your question :)
> 
> I do not know how EVIOCGRAB works, I believe event* will _still_ see

AFAIK once an opener has eviocgrab-ed the device no other opener will
receive events.

> the events. Anyway, if not, I guess EVIOCGRAB can be fixed/removed/ we
> can add EVIOCGIVEMEALLTHEDATAREALLYIWANTIT.

then probably pbuttonsd is already doing something similar to SI[NM]
hmmm... was it pbuttonsd? oh, yes:
http://pbbuttons.sourceforge.net/projects/pbbuttonsd/
-- 
mattia
:wq!
