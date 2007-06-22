Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbXFVLT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbXFVLT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 07:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXFVLTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 07:19:50 -0400
Received: from zombie.ncsc.mil ([144.51.88.131]:50047 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751554AbXFVLTs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 07:19:48 -0400
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: James Morris <jmorris@namei.org>, Pavel Machek <pavel@ucw.cz>,
       Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20070621211743.GN20105@marowsky-bree.de>
References: <20070615200623.GA2616@elf.ucw.cz>
	 <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com>
	 <20070616000251.GG2616@elf.ucw.cz>
	 <20070621160840.GA20105@marowsky-bree.de>
	 <20070621183311.GC18990@elf.ucw.cz>
	 <20070621192407.GF20105@marowsky-bree.de>
	 <Line.LNX.4.64.0706211530290.483@localhost.localdomain>
	 <20070621195400.GK20105@marowsky-bree.de>
	 <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil>
	 <20070621211743.GN20105@marowsky-bree.de>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 22 Jun 2007 07:19:39 -0400
Message-Id: <1182511179.24664.1.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-06-21 at 23:17 +0200, Lars Marowsky-Bree wrote:
> On 2007-06-21T16:59:54, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> 
> > Or can access the data under a different path to which their profile
> > does give them access, whether in its final destination or in some
> > temporary file processed along the way.
> 
> Well, yes. That is intentional.
> 
> Your point is?

It may very well be unintentional access, especially when taking into
account wildcards in profiles and user-writable directories.

> > The emphasis on never modifying applications for security in AA likewise
> > has an adverse impact here, as you will ultimately have to deal with
> > application mediation of access to their own objects and operations not
> > directly visible to the kernel (as we have already done in SELinux for
> > D-BUS and others and are doing for X).  Otherwise, your "protection" of
> > desktop applications is easily subverted.
> 
> That is an interesting argument, but not what we're discussing here.
> We're arguing filesystem access mediation.

IOW, anything that AA cannot protect against is "out of scope".  An easy
escape from any criticism.

> > Um, no.  It might not be able to directly open files via that path, but
> > showing that it can never read or write your mail is a rather different
> > matter.
> 
> Yes. Your use case is different than mine.

My use case is being able to protect data reliably.  Yours?

-- 
Stephen Smalley
National Security Agency

