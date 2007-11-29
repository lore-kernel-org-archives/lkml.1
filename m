Return-Path: <linux-kernel-owner+w=401wt.eu-S1762802AbXK2RQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762802AbXK2RQR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758315AbXK2RQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:16:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44174 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126AbXK2RQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:16:02 -0500
Date: Thu, 29 Nov 2007 09:14:26 -0800
From: Greg KH <greg@kroah.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Valdis.Kletnieks@vt.edu,
       Christoph Hellwig <hch@infradead.org>, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
Message-ID: <20071129171426.GD10024@kroah.com>
References: <416908.77038.qm@web36613.mail.mud.yahoo.com> <20071128164613.GA21815@infradead.org> <25290.1196273705@turing-police.cc.vt.edu> <20071128183040.GW8181@ftp.linux.org.uk> <20071129003840.GA22530@kroah.com> <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr> <20071129010753.GA19106@kroah.com> <1196354172.6473.52.camel@perihelion> <20071129164746.GB9664@kroah.com> <1196355936.6473.74.camel@perihelion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196355936.6473.74.camel@perihelion>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 12:05:36PM -0500, Jon Masters wrote:
> 
> On Thu, 2007-11-29 at 08:47 -0800, Greg KH wrote:
> > On Thu, Nov 29, 2007 at 11:36:12AM -0500, Jon Masters wrote:
> > > On Wed, 2007-11-28 at 17:07 -0800, Greg KH wrote:
> > > 
> > > > The easiest way is as Al described above, just have the userspace
> > > > program that wrote the file to disk, check it then.
> > > 
> > > But the problem is that this isn't just Samba, this is a countless
> > > myriad of different applications. And if one of them doesn't support
> > > on-access scanning, then the whole solution isn't worth using.
> > 
> > Ok, which specific applications do they care about?  Last time I asked
> > it was still limited to a very small handful, all of which would be
> > trivial to add such a hook to.
> 
> Like I said, I'm trying to put together a set of "feature requirements"
> that we can publish to LKML and get feedback.

Heh, ok, I did this a while ago, but I'd be interested in seeing this
done in public, on lkml this time around so that we have a thread to
point people at in the future when it comes up again :)

good luck,

greg k-h
