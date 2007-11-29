Return-Path: <linux-kernel-owner+w=401wt.eu-S1762940AbXK2SzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762940AbXK2SzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758399AbXK2Sy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:54:57 -0500
Received: from bbasa1.bakbone.com ([209.126.247.190]:62723 "EHLO
	mail.bakbone.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758105AbXK2Sy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:54:57 -0500
X-Greylist: delayed 1995 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Nov 2007 13:54:56 EST
From: Justin Banks <justinb@bakbone.com>
Date: Thu, 29 Nov 2007 11:19:57 -0700
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Greg KH <greg@kroah.com>, Jan Engelhardt <jengelh@computergmbh.de>,
       Jon Masters <jonathan@jonmasters.org>, Valdis.Kletnieks@vt.edu,
       Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071129181957.GA5575@bleen.corp.bb>
References: <20071129003840.GA22530@kroah.com> <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr> <20071129010753.GA19106@kroah.com> <1196354172.6473.52.camel@perihelion> <20071129164746.GB9664@kroah.com> <Pine.LNX.4.64.0711291752550.13075@fbirervta.pbzchgretzou.qr> <20071129170326.GA10024@kroah.com> <2c0942db0711290935l56d28b70v2b35dfb1663e4d2b@mail.gmail.com> <20071129174528.GA14431@kroah.com> <2c0942db0711291003h45177f3cr5496cf30bdb01996@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0711291003h45177f3cr5496cf30bdb01996@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote
> On Nov 29, 2007 9:45 AM, Greg KH <greg@kroah.com> wrote:
> > > Perhaps if you looked at this outside of a file-server scenario, the
> > > problem would be clearer? Anti-malware companies want to check
> > > anything written to disk on a system, either at write time or blocking
> > > the open/mmap. That means proactively protecting email programs with
> > > known vulnerabilities that have yet to be patched, web browsers
> > > writing and reading their caches, an Apache instance running WebDAV,
> > > the list goes on. And these are on desktop systems, with no attached
> > > file/network server.
> >
> > Ok, if they want to check on every open/mmap then just hook in glibc to
> > do this.  Especially as they want to run userspace code at this point in
> > time.
> 
> Doesn't help statically linked binaries, or anything else that bypases glibc.

Or NFS servers for that matter, either.

-justinb

-- 
Justin Banks
BakBone Software
justinb@bakbone.com
