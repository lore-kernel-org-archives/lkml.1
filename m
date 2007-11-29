Return-Path: <linux-kernel-owner+w=401wt.eu-S1763372AbXK2Qtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763372AbXK2Qtn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762395AbXK2Qsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:48:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60830 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762283AbXK2Qsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:48:41 -0500
Date: Thu, 29 Nov 2007 08:47:46 -0800
From: Greg KH <greg@kroah.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Valdis.Kletnieks@vt.edu,
       Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071129164746.GB9664@kroah.com>
References: <20071128144156.GA14106@infradead.org> <416908.77038.qm@web36613.mail.mud.yahoo.com> <20071128164613.GA21815@infradead.org> <25290.1196273705@turing-police.cc.vt.edu> <20071128183040.GW8181@ftp.linux.org.uk> <20071129003840.GA22530@kroah.com> <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr> <20071129010753.GA19106@kroah.com> <1196354172.6473.52.camel@perihelion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196354172.6473.52.camel@perihelion>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 11:36:12AM -0500, Jon Masters wrote:
> On Wed, 2007-11-28 at 17:07 -0800, Greg KH wrote:
> 
> > The easiest way is as Al described above, just have the userspace
> > program that wrote the file to disk, check it then.
> 
> But the problem is that this isn't just Samba, this is a countless
> myriad of different applications. And if one of them doesn't support
> on-access scanning, then the whole solution isn't worth using.

Ok, which specific applications do they care about?  Last time I asked
it was still limited to a very small handful, all of which would be
trivial to add such a hook to.

> > There are some nice SAMBA plugins that do just that already out there...
> 
> That's really not the problem :-)

Yes it is.  That's all you want to catch, when a Windows machine wants
to access a file on a SAMBA server.  Do the check then, in userspace.

Believe me, I've been over and over and over and over this before...

thanks,

greg k-h
