Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbXGCVan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbXGCVan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760623AbXGCVa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:30:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46557 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760470AbXGCVaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:30:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 23:37:51 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
References: <20070703211227.GA28758@srcf.ucam.org> <Pine.LNX.4.44L0.0707031713530.8010-100000@iolanthe.rowland.org> <20070703212002.GA28895@srcf.ucam.org>
In-Reply-To: <20070703212002.GA28895@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707032337.52544.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 3 July 2007 23:20, Matthew Garrett wrote:
> On Tue, Jul 03, 2007 at 05:16:37PM -0400, Alan Stern wrote:
> > On Tue, 3 Jul 2007, Matthew Garrett wrote:
> > > But that's fine - "Are we undergoing a systemwide suspend" is an easy 
> > > question to ask. Freezing processes instead means that most of those 
> > > paths will never be tested.
> > 
> > The question is easy to ask, but it's not so easy to figure out what
> > you should do if the answer is Yes.  Freezing processes instead means
> > that those "untested" paths -- in many, many drivers -- won't have to 
> > exist at all.
> 
> We're used to the idea of applications blocking when a resource they're 
> using goes away - NFS has done it forever. 

Now, please tell me how many driver writers even thought that something
might try to access their devices after .suspend() had been executed (or
even whilie it was being executed)?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
