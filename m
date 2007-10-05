Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbXJEHBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbXJEHBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 03:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbXJEHBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 03:01:10 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:8261 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbXJEHBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 03:01:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ozb0JM+Odpe3T04LkGxQtHhd0V58KOUgnvL0VD0Ey8i2JhMv9JLrn9qa7/uIbEA1H+ieWIjpl+n0koRIdtu50rv3Qbw56QGHDe8iSuvkFQzBant/mRF0V1Tdi8cw2FwaZbd7rSbRNzLMJ0AVIZXsA2svtMHM4fHFVKy2LA2tHNI=
Message-ID: <653402b90710050001k29ed8e3by1ccc4a0ede818b9f@mail.gmail.com>
Date: Fri, 5 Oct 2007 09:01:08 +0200
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "linux@horizon.com" <linux@horizon.com>
In-Reply-To: <200710042059.25721.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1191528247.13580.11.camel@grianne>
	 <20071004131703.25046db9.randy.dunlap@oracle.com>
	 <200710042059.25721.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/07, Rob Landley <rob@landley.net> wrote:
> On Thursday 04 October 2007 3:17:03 pm Randy Dunlap wrote:
> > On Thu, 04 Oct 2007 22:04:07 +0200 Vegard Nossum wrote:
> > > Description: This patch largely implements the kprint API as previously
> > > posted to the LKML and described in Documentation/kprint.txt (see patch).
> > >
> > > The main purpose of this change is provide a unified logging API to the
> > > kernel and at the same time make it easy to add extensions, now and
> > > later.
> > >
> > > My changes and additions are as follows:
> >
> > $ diffstat -p1 -w70 kprint.patch
> ...
> >  40 files changed, 1660 insertions(+), 72 deletions(-)
>
> I started this thread by posting an idea I had for shrinking the kernel by
> allowing more code to be configured out.  The API change was exactly one new
> parameter, with a direct 1->1 mapping from the old API to the new one, which
> was trivial to convert and which the compiler would catch if you missed one.
>
> The result of the discussion is a patch adding 1600 lines to the kernel,
> without removing anything.
>
> Last I checked, the current prink() worked just fine.  Why is this _not_ the
> dreaded "infrastructure in search of a use"?  What exactly can we _not_ do
> with the current code?  What does this allow us to remove and simplify?
>
> I'm confused about what people are trying to accomplish here...
>

I think we all are trying to give ideas to improve the current logging API.

If something works, it's great; but it doesn't mean that it can't be
improved, right?

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
