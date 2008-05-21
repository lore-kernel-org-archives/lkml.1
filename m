Return-Path: <linux-kernel-owner+w=401wt.eu-S935583AbYEUPuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935583AbYEUPuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 11:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932202AbYEUPuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 11:50:18 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:50579 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbYEUPuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 11:50:16 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/F8JU58KL/Av7SOqBAJcDo
Date: Wed, 21 May 2008 08:50:03 -0700
From: Tony Lindgren <tony@atomide.com>
To: Bryan Wu <cooloney@kernel.org>
Cc: Felipe Balbi <me@felipebalbi.com>, David Brownell <david-b@pacbell.net>,
       linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] MUSB: 2 patches to fix some bug found on Blackfin
Message-ID: <20080521155003.GZ23002@atomide.com>
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org> <200805170737.37806.david-b@pacbell.net> <386072610805182339n2e141b83q4b8f9804194088e4@mail.gmail.com> <71636ee466dd53c366eb11d8fc981e8b@felipebalbi.com> <386072610805190105y6618dd9bwe32503c1ae11b865@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <386072610805190105y6618dd9bwe32503c1ae11b865@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bryan Wu <cooloney@kernel.org> [080519 01:06]:
> On Mon, May 19, 2008 at 3:49 PM, Felipe Balbi <me@felipebalbi.com> wrote:
> >
> >
> > On Mon, 19 May 2008 14:39:10 +0800, "Bryan Wu" <cooloney@kernel.org> wrote:
> >> On Sat, May 17, 2008 at 10:37 PM, David Brownell <david-b@pacbell.net>
> >> wrote:
> >>> On Saturday 17 May 2008, Bryan Wu wrote:
> >>>>
> >>>> We discussed these 4 bugs before. Now we fixed them.
> >>>> Please review following 2 patches.
> >>>
> >>> They looked plausible to me ... though the urb->status
> >>> one is a bit of a band-aid, and when that field finally
> >>> vanishes a better fix will be needed.
> >>>
> >>

I'll push these to linux-omap tree then.

> >> OK, so is there any plan for merge the MUSB to mainline and finally to
> >> remove the urb->status?
> >
> > I was planing to do this by the end of this year or as soon as I make all
> > usb if tests pass again. I'm out of tools for that right now :-s
> >
> 
> Great, after I enable the DMA mode 1 on Blackfin and cleanup the code,
> I will send
> out the code before you sent them to upstream

Maybe we should get the musb code to USB tree before that? It's been out
of the scope for linux-omap tree for quite a while now.

Tony
