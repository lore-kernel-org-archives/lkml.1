Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbZALVs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbZALVs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 16:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbZALVsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 16:48:50 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:16184 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbZALVst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 16:48:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Q5O4i6Z7nW4OYbm+9SG07l3R5uSf28WUP9wy1Hw74fevzsS9CsAzDgRdINPsoY0CPY
         ekNdQcInmnDExHOjL+Dn7GQj2wWwb0/xorAnml6pA0b9NtnJ+DzldStGQIrU6yGXGzkH
         RldmK9zeaPew/wdWAh136zS4td4fkJhkROR00=
Date: Tue, 13 Jan 2009 00:48:44 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Subject: Re: Can we get warnings from the x86 userspace headers fixed?
Message-ID: <20090112214844.GF13384@localhost>
References: <20090112212855.GB15185@uranus.ravnborg.org> <1231795863.5405.8.camel@brick> <20090112213719.GC7320@elte.hu> <20090112214420.GE13384@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112214420.GE13384@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Tue, Jan 13, 2009 at 12:44:20AM +0300]
| [Ingo Molnar - Mon, Jan 12, 2009 at 10:37:19PM +0100]
| | 
| | * Harvey Harrison <harvey.harrison@gmail.com> wrote:
| | 
| | > On Mon, 2009-01-12 at 22:28 +0100, Sam Ravnborg wrote:
| | > > Hi Ingo.
| | > > 
| | > > We have recently introduced a lot of new warnings for our
| | > > userspace headers.
| | > > 
| | > > Try to do a "make headers_check" and enjoy...
| | > > 
| | > > Are there any chance you could ask one of your helpers to
| | > > start to look into the x86 specific ones?
| | > > 
| | > > If we get x86 clean this would create more incentive to
| | > > make the generic clean too.
| | > > 
| | > > I had originally planned to attack the generic headers
| | > > (include/linux/*) but I'm faced by reality after my
| | > > vacation and has almost no spare time for the time being.
| | > > 
| | > > I already fixed the sparc headers but that is not 
| | > > visible compared to x86 (the fixes was btw easy).
| | > > 
| | > > I can try to help by doing a few reviews in the
| | > > beginning but I need to fix kbuild stuff first where
| | > > I have a few serious issues pending. And lacks time...
| | > > 
| | > 
| | > I'll have a go at some of them this afternoon unless someone beats me to 
| | > it.
| | 
| | thanks Harvey! Please work against tip/master if you do that, there's a 
| | few header file changes in the queue already.
| | 
| | 	Ingo
| | 
| 
| hmm... what I've got:
| 
| ---
| cyrill@lenovo linux-2.6.git $ make headers_check
|   CHK     include/linux/version.h
| make[1]: `scripts/unifdef' is up to date.
| cyrill@lenovo linux-2.6.git $ 
| ---
| 
| I don't know what to think...
| 
| 		- Cyrill -

Just checked out last -tip. Ugh, damn, so many warnings... :(

		- Cyrill -
