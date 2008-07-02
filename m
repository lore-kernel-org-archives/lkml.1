Return-Path: <linux-kernel-owner+w=401wt.eu-S1761747AbYGBCtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761747AbYGBCtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757927AbYGBCs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:48:57 -0400
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:42201 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754393AbYGBCs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:48:56 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] 2.6.26-rc: x86: pci-dma.c: use __GFP_NO_OOM instead of __GFP_NORETRY
Date: Tue, 1 Jul 2008 19:48:49 -0700
User-Agent: KMail/1.9.9
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Miquel van Smoorenburg" <mikevs@xs4all.net>,
       linux-kernel@vger.kernel.org
References: <20080526234940.GA1376@xs4all.net> <200807011939.53427.jbarnes@virtuousgeek.org> <86802c440807011946m47fcba2h3b10be091fc7547f@mail.gmail.com>
In-Reply-To: <86802c440807011946m47fcba2h3b10be091fc7547f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011948.50181.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 01, 2008 7:46 pm Yinghai Lu wrote:
> On Tue, Jul 1, 2008 at 7:39 PM, Jesse Barnes <jbarnes@virtuousgeek.org> 
wrote:
> > On Thursday, June 26, 2008 4:38 am Ingo Molnar wrote:
> >> that branch is always based in -git so if stuff goes upstream patches
> >> disappear from it. git-log linus/master..tip/pci-for-jesse should tell
> >> the currently pending items. Right now it's just two lowprio items:
> >>
> >>  Yinghai Lu (2):
> >>       pci: debug extra pci resources range
> >>       pci: debug extra pci bus resources
> >
> > It looks like these add some new, unconditional debug output?  I guess I
> > shouldn't worry about printks so much at this point, given how much
> > obsolete/uninteresting info gets dumped these days, but it would be nice
> > if this were only dumped if some debug option were set.  Given the
> > variety of PCI stuff we might like to dump at various times, maybe it's
> > time we added a few new pci=debug=foo options?  Yinghai?
>
> that is just limited printout. and it is informative..
> that is BAR before kernel try to assign new value to it.

Yeah, and it's in keeping with the early (pre-assignment) BAR dumping code you 
added elsewhere.  I'm fine with it as-is, I'll revisit finer grained debug 
options in a future release and fix things up then as needed.

Thanks,
Jesse
