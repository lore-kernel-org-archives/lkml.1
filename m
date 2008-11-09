Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbYKILcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbYKILcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 06:32:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYKILb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 06:31:57 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45163 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbYKILb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 06:31:56 -0500
Date: Sun, 9 Nov 2008 12:33:32 +0100
From: Pavel Machek <pavel@suse.cz>
To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       yakui.zhao@intel.com, bugme-daemon@bugzilla.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
Subject: Re: [Bugme-new] [Bug 11717] New: Pressing suspend button suspends,
	but does not wakes up
Message-ID: <20081109113332.GD6094@elf.ucw.cz>
References: <20081106194724.GB15366@ime.usp.br> <20081107014535.GA19201@ime.usp.br> <1226044855.4913f5b7f2f45@webmail.ime.usp.br> <20081108075008.GA8177@ime.usp.br> <dd18b0c30811080020i23418742xc6388a5942456566@mail.gmail.com> <20081109024514.GA11744@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081109024514.GA11744@ime.usp.br>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-11-09 00:45:14, Rogério Brito wrote:
> Hi, Justin and others.
> 
> On Nov 08 2008, Justin Mattock wrote:
> > On Fri, Nov 7, 2008 at 11:50 PM, Rogério Brito <rbrito@ime.usp.br> wrote:
> > > I think that I have some more information regarding the suspend/hibernate
> > > issue: with Ubuntu's 2.6.27 kernel, I can't hibernate my laptop, but with
> > > vanilla 2.6.28-rc3, I can hibernate (I have not tested it much, but it
> > > seems to work).
> 
> Just some extra information here: while I can hibernate with vanilla
> 2.6.28-rc3, upon resuming, it takes *minutes* (I don't know how many
> minutes, but probably something like 5 minutes or so!) for the desktop to
> have any effect (despite the fact that I can move the mouse without any
> problems).

Try it from the text console, and see what exactly stops
responding. "killall klogd" is your friend.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
