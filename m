Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbYDIUR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbYDIUR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 16:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbYDIURV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 16:17:21 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3531 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbYDIURU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 16:17:20 -0400
Date: Wed, 9 Apr 2008 21:16:52 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       SL Baur <steve@xemacs.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Richard Knutsson <ricknu-0@student.ltu.se>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch] checkpatch: relax spacing and line length
Message-ID: <20080409201652.GS17915@shadowen.org>
References: <alpine.LNX.1.10.0804060653020.30794@fbirervta.pbzchgretzou.qr> <20080408171257.GF17915@shadowen.org> <47FCB458.3070403@panasas.com> <20080409132548.GM17915@shadowen.org> <47FCF6AF.8010703@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FCF6AF.8010703@panasas.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 08:02:39PM +0300, Benny Halevy wrote:
> On Apr. 09, 2008, 16:25 +0300, Andy Whitcroft <apw@shadowen.org> wrote:
> > On Wed, Apr 09, 2008 at 03:19:36PM +0300, Benny Halevy wrote:
> >> On Apr. 08, 2008, 20:12 +0300, Andy Whitcroft <apw@shadowen.org> wrote:
> >>> To justify changing checkpatch to loosen its checks I would hope to see
> >>> an agreed to change to the CodingStyle detailing actually what is now
> >>> acceptable.
> >> For reference, here's Jan's proposal for Documentation/CodingStyle:
> >> http://lkml.org/lkml/2008/2/26/462
> > 
> > Yes, seems reasonably well worded.  However, I see no consensus for its
> > acceptance as a change.  I seem some near NAK's.
> 
> but no definite one :)
> > 
> > -apw
> 
> Seriously, I'm not sure how significant or relevant they are though.
> 
> In http://lkml.org/lkml/2008/2/26/533,
> SL Baur <steve <at> xemacs.org> said:
> > The proposed two space change is ugly.  Can someone NAK it?
> 
> I'm not sure what "two space change" proposal this Steve referred to
> and his rejection is based on not-to-sound aesthetic grounds.
> 
> The motivation behind our proposal is more than just aesthetic.
> I believe that using tabs for indent and then spaces for alignment
> is functionally better, works for everybody, and will eventually result
> in a more readable code over time, hopefully leading to fewer bugs.

I don't see it as really anything other than different.  It'll look better
for you, sure.  But either we (tabs=8 people) will not be maintaining it
as we edit leading to inconsistent indent, or we will be putting in lots
of effort to maintain something we can't even see.

> Randy's answer, http://lkml.org/lkml/2008/2/27/7
> says he won't NAK it since:
> > I would gladly NAK it, but most recent email from Linus about
> > coding style is that we are getting too detailed about it,
> > so unless there is some overwhelming need to change anything in
> > CodingStyle, I'm for no changes (or maybe even some removals).
> 
> My interpretation of that is the the current CodingStyle is too detailed
> *now* therefore we need to relax it, not keep it the way it is.
> It's true, that we add more details to relax the requirements but
> overall we'd allow for more flexibility.  To do that with removing
> details rather than adding any is dangerous IMO since it can easily
> lead to indentation chaos that makes everybody's life harder...

But that is your option.  Right now the rule is simple, use tabs, only.
Either we relax that and get inconsistent indent from the two camps _or_
you add rules and we all have to follow your new spaces for align form.

> Richard Knutsson, in http://lkml.org/lkml/2008/2/28/356
> adds an excellent point about needing smaller tab expansion
> for narrow screens.
> 
> Stefan Richter in http://lkml.org/lkml/2008/2/26/523 commented:
> > Jan Engelhardt, Benny Halevy, and Richard Knutsson wrote:
> > > -Tabs are 8 characters, and thus indentations are also 8 characters.
> > > -There are heretic movements that try to make indentations 4 (or even 2!)
> > > -characters deep, and that is akin to trying to define the value of PI to
> > > -be 3.
> > 
> > Don't do this
> 
> Again, I see no real reasons why not to besides being against Stefan's
> preferences.  I repeat my point that the proposed style does not
> necessarily encourage smaller tab expansion, it just makes it possible.
> 
> Well, enough said.
> Back to fixin' bugs...

Indeed.

-apw
