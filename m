Return-Path: <linux-kernel-owner+w=401wt.eu-S936139AbXGSQRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936139AbXGSQRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 12:17:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936750AbXGSQRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 12:17:16 -0400
Received: from canuck.infradead.org ([209.217.80.40]:53804 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936011AbXGSQRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 12:17:13 -0400
Date: Thu, 19 Jul 2007 09:01:28 -0700
From: Greg KH <greg@kroah.com>
To: Jim Kovaric <jkovaric@us.ibm.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, serue@linux.vnet.ibm.com
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719160128.GA13199@kroah.com>
References: <OF54A17BCF.9A1D7004-ON8725731D.0044828E-8625731D.0046CAED@us.ibm.com> <Line.LNX.4.64.0707190901200.4393@d.namei> <Line.LNX.4.64.0707190912520.4393@d.namei>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0707190912520.4393@d.namei>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 09:19:56AM -0400, James Morris wrote:
> On Thu, 19 Jul 2007, James Morris wrote:
> 
> > On Thu, 19 Jul 2007, Jim Kovaric wrote:
> > 
> > > IBMs  TAMOS (Tivoli Access Manager for Operating systems) contains a 
> > > loadable module,
> > >  which is an "out of tree module",  and registers "itself"  as a security 
> > > module during the TAMOS startup
> > > process. It also requires that SElinux  be "disabled"
> > 
> > Please provide a link to the source code, so we can understand how you're 
> > using the API.
> 
> I think I've found it:
> 
> ftp://ftp.software.ibm.com/software/tivoli_support/patches/patches_6.0.0/6.0.0-TIV-PDO-FP0007/6.0.0-TIV-PDO-Linux.i386-FP0007.tar
> 
> Is that correct?

If so, that code seems to have been run through a "code obfuscator" and
as such, is not abiding by the GPL.  Can IBM please post the real code
as the GPL requires?

Jim, if you are not the person to make this request too, can you point
me at the correct person?

thanks,

greg k-h
