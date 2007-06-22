Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbXFVMUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbXFVMUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 08:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbXFVMUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 08:20:41 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:37963 "EHLO jazzhorn.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751987AbXFVMUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 08:20:39 -0400
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Crispin Cowan <crispin@novell.com>
Cc: James Morris <jmorris@namei.org>, Chris Mason <chris.mason@oracle.com>,
       Lars Marowsky-Bree <lmb@suse.de>, Pavel Machek <pavel@ucw.cz>,
       Greg KH <greg@kroah.com>, Andreas Gruenbacher <agruen@suse.de>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <467B4D61.3020509@novell.com>
References: <20070615200623.GA2616@elf.ucw.cz>
	 <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com>
	 <20070616000251.GG2616@elf.ucw.cz>
	 <20070621160840.GA20105@marowsky-bree.de>
	 <20070621183311.GC18990@elf.ucw.cz>
	 <20070621192407.GF20105@marowsky-bree.de>
	 <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
	 <20070621195400.GK20105@marowsky-bree.de>
	 <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
	 <20070622003436.GB6222@think.oraclecorp.com>
	 <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
	 <467B4D61.3020509@novell.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 22 Jun 2007 08:20:16 -0400
Message-Id: <1182514816.24664.49.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 22:17 -0600, Crispin Cowan wrote:
> James Morris wrote:
> > On Thu, 21 Jun 2007, Chris Mason wrote:  
> >>> The incomplete mediation flows from the design, since the pathname-based
> >>> mediation doesn't generalize to cover all objects unlike label- or
> >>> attribute-based mediation.  And the "use the natural abstraction for
> >>> each object type" approach likewise doesn't yield any general model or
> >>> anything that you can analyze systematically for data flow.
> >>>       
> >> This feels quite a lot like a repeat of the discussion at the kernel
> >> summit.  There are valid uses for path based security, and if they don't
> >> fit your needs, please don't use them.  But, path based semantics alone
> >> are not a valid reason to shut out AA.
> >>     
> > The validity or otherwise of pathname access control is not being 
> > discussed here.
> >
> > The point is that the pathname model does not generalize, and that 
> > AppArmor's inability to provide adequate coverage of the system is a 
> > design issue arising from this.
> >   
> The above two paragraphs appear to contradict each other.
> 
> > Recall that the question asked by Lars was whether there were any 
> > outstanding technical issues relating to AppArmor.
> >
> > AppArmor does not and can not provide the level of confinement claimed by 
> > the documentation, and its policy does not reflect its actual confinement 
> > properties.  That's kind of a technical issue, right?
> >   
> So if the document said "confinement with respect to direct file access
> and POSIX.1e capabilities" and that list got extended as AA got new
> confinement features, would that address your issue?

That would certainly help, although one might quibble with the use of
the word "confinement" at all wrt AppArmor (it has a long-established
technical meaning that implies information flow control, and that goes
beyond even complete mediation - it requires global and persistent
protection of the data based on its properties, which requires stable
and unambiguous identifiers).

-- 
Stephen Smalley
National Security Agency

