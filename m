Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbXFVBGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbXFVBGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 21:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbXFVBGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 21:06:46 -0400
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:56932 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbXFVBGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 21:06:44 -0400
Date: Thu, 21 Jun 2007 21:06:40 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Chris Mason <chris.mason@oracle.com>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Lars Marowsky-Bree <lmb@suse.de>,
       Pavel Machek <pavel@ucw.cz>, Crispin Cowan <crispin@novell.com>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
In-Reply-To: <20070622003436.GB6222@think.oraclecorp.com>
Message-ID: <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
References: <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com>
 <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz>
 <20070621160840.GA20105@marowsky-bree.de> <20070621183311.GC18990@elf.ucw.cz>
 <20070621192407.GF20105@marowsky-bree.de> <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
 <20070621195400.GK20105@marowsky-bree.de> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
 <20070622003436.GB6222@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Chris Mason wrote:

> > The incomplete mediation flows from the design, since the pathname-based
> > mediation doesn't generalize to cover all objects unlike label- or
> > attribute-based mediation.  And the "use the natural abstraction for
> > each object type" approach likewise doesn't yield any general model or
> > anything that you can analyze systematically for data flow.
> 
> This feels quite a lot like a repeat of the discussion at the kernel
> summit.  There are valid uses for path based security, and if they don't
> fit your needs, please don't use them.  But, path based semantics alone
> are not a valid reason to shut out AA.

The validity or otherwise of pathname access control is not being 
discussed here.

The point is that the pathname model does not generalize, and that 
AppArmor's inability to provide adequate coverage of the system is a 
design issue arising from this.

Recall that the question asked by Lars was whether there were any 
outstanding technical issues relating to AppArmor.

AppArmor does not and can not provide the level of confinement claimed by 
the documentation, and its policy does not reflect its actual confinement 
properties.  That's kind of a technical issue, right?


- James
-- 
James Morris
<jmorris@namei.org>
