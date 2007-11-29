Return-Path: <linux-kernel-owner+w=401wt.eu-S932836AbXK2SjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbXK2SjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:39:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759497AbXK2SjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:39:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055AbXK2SjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:39:06 -0500
Subject: Re: Out of tree module using LSM
From: Jon Masters <jcm@redhat.com>
To: Justin Banks <justinb@bakbone.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, Greg KH <greg@kroah.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, Valdis.Kletnieks@vt.edu,
       Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071129181957.GA5575@bleen.corp.bb>
References: <20071129003840.GA22530@kroah.com>
	 <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr>
	 <20071129010753.GA19106@kroah.com> <1196354172.6473.52.camel@perihelion>
	 <20071129164746.GB9664@kroah.com>
	 <Pine.LNX.4.64.0711291752550.13075@fbirervta.pbzchgretzou.qr>
	 <20071129170326.GA10024@kroah.com>
	 <2c0942db0711290935l56d28b70v2b35dfb1663e4d2b@mail.gmail.com>
	 <20071129174528.GA14431@kroah.com>
	 <2c0942db0711291003h45177f3cr5496cf30bdb01996@mail.gmail.com>
	 <20071129181957.GA5575@bleen.corp.bb>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Thu, 29 Nov 2007 13:38:28 -0500
Message-Id: <1196361508.6473.88.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-29 at 11:19 -0700, Justin Banks wrote:
> Ray Lee wrote
> > On Nov 29, 2007 9:45 AM, Greg KH <greg@kroah.com> wrote:
> > > > Perhaps if you looked at this outside of a file-server scenario, the
> > > > problem would be clearer? Anti-malware companies want to check
> > > > anything written to disk on a system, either at write time or blocking
> > > > the open/mmap. That means proactively protecting email programs with
> > > > known vulnerabilities that have yet to be patched, web browsers
> > > > writing and reading their caches, an Apache instance running WebDAV,
> > > > the list goes on. And these are on desktop systems, with no attached
> > > > file/network server.
> > >
> > > Ok, if they want to check on every open/mmap then just hook in glibc to
> > > do this.  Especially as they want to run userspace code at this point in
> > > time.
> > 
> > Doesn't help statically linked binaries, or anything else that bypases glibc.
> 
> Or NFS servers for that matter, either.

Right. I threw all of these examples out there and was given the
impression that a one-size fits all "solution" is needed. And to be
honest, I can understand that desire.

I don't want to fall into any "snake oil" traps, because I know the
reality is that there are holes in any solution. The only way
to /really/ be sure of file integrity is to mark every user-visible
pagecache page read only, trap on every single write, and re-scan the
entirety of the file at that point. And even more silliness.

A compromise is therefore called for. I will go shut up and go talk to
these guys and see if I can hook up a public discussion around a set of
requirements. Preferably some code too, but at least a requirements doc.

Thanks,

Jon.


