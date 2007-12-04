Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbXLDICR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbXLDICR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 03:02:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXLDICI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 03:02:08 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:58284 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028AbXLDICH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 03:02:07 -0500
Date: Tue, 4 Dec 2007 03:02:02 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Greg KH <gregkh@suse.de>
cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: The use of KOBJ_NAME_LEN
In-Reply-To: <20071204074656.GB25316@suse.de>
Message-ID: <alpine.LFD.0.9999.0712040301380.3025@localhost.localdomain>
References: <20071204064547.GA17094@darkstar.lan> <alpine.LFD.0.9999.0712040150010.31686@localhost.localdomain> <20071204074656.GB25316@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007, Greg KH wrote:

> On Tue, Dec 04, 2007 at 01:50:53AM -0500, Robert P. J. Day wrote:
> > On Tue, 4 Dec 2007, Dave Young wrote:
> >
> > > Hi,
> > > Does the KOBJ_NAME_LEN really means the limit of kobject name length? seems not . And if it's true, is the KOBJ_NAME_LEN of 20 enough to use?
> > >
> > > In the kobject_set_name, the limit is 1024. Looks like either the comment or the code should be updated.
> > >
> > > /**
> > >  *      kobject_set_name - Set the name of an object
> > >  *      @kobj:  object.
> > >  *      @fmt:   format string used to build the name
> > >  *
> > >  *      If strlen(name) >= KOBJ_NAME_LEN, then use a dynamically allocated
> > >  *      string that @kobj->k_name points to. Otherwise, use the static
> > >  *      @kobj->name array.
> > >  */
> >
> > the comment seems fairly clear -- if the name is sufficiently short,
> > it's stored in the static array.  if not, then it's stored in
> > dynamically allocated space.
>
> Unfortunately, it's totally wrong, the code was updated by the comment
> wasn't, sorry.  See my patch to fix this.

ah, quite right, now i see what dave was talking about.

rday
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
