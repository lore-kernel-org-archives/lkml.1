Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbXKSHPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbXKSHPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 02:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbXKSHPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 02:15:01 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41491
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752189AbXKSHPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 02:15:00 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Patch] Fix UML broken (was Re: User Mode Linux still broken in 2.6.23.1)
Date: Mon, 19 Nov 2007 01:14:55 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jeff Dike <jdike@addtoit.com>, Greg KH <greg@kroah.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Chris Wright <chrisw@sous-sol.org>
References: <200711032351.52977.rob@landley.net> <200711181417.50745.rob@landley.net> <20071118213203.GA5696@uranus.ravnborg.org>
In-Reply-To: <20071118213203.GA5696@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711190114.55604.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 November 2007 15:32:03 Sam Ravnborg wrote:
> On Sun, Nov 18, 2007 at 02:17:49PM -0600, Rob Landley wrote:
> > On Saturday 17 November 2007 12:53:57 Jeff Dike wrote:
> > > On Fri, Nov 16, 2007 at 04:00:22PM -0600, Rob Landley wrote:
> > > > I wasn't cc'd, and missed it.  I'd like to test this, do you have a
> > > > link?  (Or a bit more specificity than "a few weeks ago"?)
> > >
> > > Here are the three patches:
> > >
> > > 	http://marc.info/?l=linux-arch&m=119342916329510&w=2
> >
> > Doesn't contain a patch.
>
> Took me one minute to locate PATCH 1 + 2:
> http://marc.info/?l=linux-arch&m=119342916429513&w=2
> http://marc.info/?l=linux-arch&m=119342916229500&w=2
>
> Maybe this helps you.

Same problem as previous message: they don't apply to 2.6.23.  (I tried both 
2.6.23 and 2.6.23.8, just to be sure.)

I don't suppose putting #ifndef guards around whatever sparc.h file hasn't got 
them is a reasonable hack to get this worked around during 2.6.23.x?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
