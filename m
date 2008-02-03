Return-Path: <linux-kernel-owner+w=401wt.eu-S1763937AbYBCLtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763937AbYBCLtF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 06:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbYBCLsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 06:48:52 -0500
Received: from 2-1-3-15a.ens.sth.bostream.se ([82.182.31.214]:38584 "EHLO
	zoo.weinigel.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbYBCLsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 06:48:51 -0500
Date: Sun, 3 Feb 2008 12:48:49 +0100
From: Christer Weinigel <christer@weinigel.se>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080203124849.0226560f@weinigel.se>
In-Reply-To: <20080202191930.GA19826@kroah.com>
References: <20080125180232.GA4613@kroah.com>
	<20080202123710.42df1aa0@weinigel.se>
	<20080202191930.GA19826@kroah.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Feb 2008 11:19:30 -0800
Greg KH <greg@kroah.com> wrote:

>I do know that the current usbfs interface is a major pain, hence the
>work to create usbfs2.  I know those developers could use the help in
>getting that cleaned up and into the kernel tree.

>Also see the rapid development these days in wrappers around usbfs.
>There is competing projects right now with OpenUSB and the
>revitalization of the old libusb project.  I know those developers are
>looking for examples where their new frameworks do not meet the needs of
>developers for stuff exactly like you describe (lots of threads, async
>callbacks, high throughput, cross-platform portability, etc.)

Yes, I did spend quite a lot of time the last time looking for usable
USB APIs, and I did not manage to find any.  Unfortunately, my time is
also limited, and I'd much prefer to work on getting support for
Samsungs ARM CPUs into Linux.  When I'm doing paid work for a customer
and they want to a proprietary driver, I'm not going to spend a lot of
my free time on working around that decision.  I explain to them that
binary drivers are definitely in a grey area and they might get in
trouble about it, but at the end it is their decision.  

> > I've written multiple of them during my life as a consultant.  The
> > nature of closed source drivers is that they quite often are written
> > for custom hardware that isn't used by that many people, so you have
> > probably not seen them, but they are definitely out there in the
> > wild.
> 
> It comes down to the simple fact, if you wish to use Linux, abide by
> the license it comes under.  To do otherwise is both disenginous and
> illegal[1].
> 
> If a company wants to keep a driver closed, then use another operating
> system, it's not like there isn't other options out there.  I hear the
> BSDs and Microsoft are quite comfortable with things like that.  :)

So in other words you want to crack down on GPL violations, and you're
going to ignore anyone who does have a proprietary driver as "not
relevant" or "it can be done with usbfs" (maybe). So why even ask on
the mailing list?  Just do it.

Saying "use BSD" instead isn't a good answer for me since I don't know
BSD well enough.  And personally, I want to see Linux everywhere; I
think it's a lot better to have Linux + a proprietary driver in an
embedded system than BSD or Windows CE.  It means that the customers
get used to Linux, and if I can get them to at least contribute back a
bit (any improvements to the core kernel for example), to me that is a
lot better than giving a lot more money to BillG.

Later, when I can show them how much easier everything gets if they use
open drivers (I'd never have managed to get my latest Samsung platform
up and running as quickly as I did without the patches I got from
Sandeep Patil, and by posting my patches to his patches I got some
feedback that helped me fix a bunch of bugs).  But it usually takes
some time to convince a company that the things they get back is more
valuable than keeping things proprietary.  So I think Linux as a whole
gains a lot more by being a bit lenient about proprietary drivers.
That is why I'm opposed this change of yours.

  /Christer

