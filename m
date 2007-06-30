Return-Path: <linux-kernel-owner+w=401wt.eu-S1757985AbXF3KsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbXF3KsL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 06:48:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbXF3Kr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 06:47:58 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:33297 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbXF3Kr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 06:47:57 -0400
Date: Sat, 30 Jun 2007 13:47:52 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] automatic CC generation for patch submission
Message-ID: <20070630104752.GA26138@localdomain>
References: <20070630023451.GA21593@localdomain> <4685C549.3020602@intel.com> <20070630025425.59cbc299.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070630025425.59cbc299.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 30, 2007 at 02:54:25AM -0700, Andrew Morton wrote:
> On Fri, 29 Jun 2007 19:51:53 -0700 "Kok, Auke" <auke-jan.h.kok@intel.com> wrote:
> 
> > > Some extensions to the popular E-Mail clients might be needed 
> > > here. Also, a bot reading LKML would automatically send links 
> > > about posted patches to the other mailing lists whenever 
> > > someone forgets to add a CC.
> > > 
> > > Any comments?
> > 
> > an easier way to implement this is to add an extra field in the MAINTAINERS 
> > file, something like below. All the contact info would stay the same, closely 
> > where applicable and it would allow you to also specify specific files as well.
> 
> We already have that information in git.  Parse the git changelogs of the
> affected files, find out who works on them.

I think it's quite complex to make a reliable inference of maintainership 
information from git. Given a set of historical modifiers of a file, 
would you take the most common commiter(s), or the most common 
_recent_ commiter(s), or what? It's a bit fuzzy.
 
Moreover, it is slow in comparison and assumes the availability of 
local .git db, which wouldn't be the case for some porition of patch 
submitters.

> Not that it'll help much, given the amnount of stuff which gets
> mysteriously ignored even when the correct people are cc'ed...

Hopefully it gets ignored if it is quite low in priority. In that
case the CC is a NOP but might still be good for archiving purposes.

> (For extra giggles we could parse emailed oops and bug reports and add the
> appropriate cc's there too.  Harder.)

BTS was discussed to death already, let's not delve into that...

-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
