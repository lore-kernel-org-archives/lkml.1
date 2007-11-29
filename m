Return-Path: <linux-kernel-owner+w=401wt.eu-S1763310AbXK2RGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763310AbXK2RGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761459AbXK2RG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:06:28 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:34911 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761330AbXK2RG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:06:27 -0500
Subject: Re: Out of tree module using LSM
From: Jon Masters <jonathan@jonmasters.org>
To: Greg KH <greg@kroah.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Valdis.Kletnieks@vt.edu,
       Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071129164746.GB9664@kroah.com>
References: <20071128144156.GA14106@infradead.org>
	 <416908.77038.qm@web36613.mail.mud.yahoo.com>
	 <20071128164613.GA21815@infradead.org>
	 <25290.1196273705@turing-police.cc.vt.edu>
	 <20071128183040.GW8181@ftp.linux.org.uk> <20071129003840.GA22530@kroah.com>
	 <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr>
	 <20071129010753.GA19106@kroah.com> <1196354172.6473.52.camel@perihelion>
	 <20071129164746.GB9664@kroah.com>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Thu, 29 Nov 2007 12:05:36 -0500
Message-Id: <1196355936.6473.74.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-11-29 at 08:47 -0800, Greg KH wrote:
> On Thu, Nov 29, 2007 at 11:36:12AM -0500, Jon Masters wrote:
> > On Wed, 2007-11-28 at 17:07 -0800, Greg KH wrote:
> > 
> > > The easiest way is as Al described above, just have the userspace
> > > program that wrote the file to disk, check it then.
> > 
> > But the problem is that this isn't just Samba, this is a countless
> > myriad of different applications. And if one of them doesn't support
> > on-access scanning, then the whole solution isn't worth using.
> 
> Ok, which specific applications do they care about?  Last time I asked
> it was still limited to a very small handful, all of which would be
> trivial to add such a hook to.

Like I said, I'm trying to put together a set of "feature requirements"
that we can publish to LKML and get feedback. I am lead to believe that
they basically want to trap every file operation, of every potential
userspace program, so I don't think it's a handful at this point.

> > > There are some nice SAMBA plugins that do just that already out there...
> > 
> > That's really not the problem :-)
> 
> Yes it is.  That's all you want to catch, when a Windows machine wants
> to access a file on a SAMBA server.  Do the check then, in userspace.

Oh, I meant that if it was just Samba we'd all be home and dry by now.

> Believe me, I've been over and over and over and over this before...

Yeah. I know, I'm trying not to flog a dead horse here, but I think
there's real genuine interest here this time around. So, maybe I'm just
trying because everyone else already did, but it's worth a shot :-)

Jon.


