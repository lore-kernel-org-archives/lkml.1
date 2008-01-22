Return-Path: <linux-kernel-owner+w=401wt.eu-S1756011AbYAVU42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbYAVU42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbYAVU4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:56:17 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37884 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbYAVU4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:56:16 -0500
Date: Tue, 22 Jan 2008 14:56:16 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linuxram@us.ibm.com, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
Subject: Re: [RFC][PATCH] VFS: create /proc/<pid>/mountinfo
Message-ID: <20080122205616.GA1506@sergelap.austin.ibm.com>
References: <E1JGBVq-0002Or-H1@pomaz-ex.szeredi.hu> <1200944886.2988.27.camel@ram.us.ibm.com> <E1JH49E-0006d6-N9@pomaz-ex.szeredi.hu> <1200952394.2988.70.camel@ram.us.ibm.com> <E1JH4po-0006ju-TS@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JH4po-0006ju-TS@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> > On Mon, 2008-01-21 at 22:25 +0100, Miklos Szeredi wrote:
> > > > 	You have removed the code that checked if the peer or
> > > > 	master mount was in the same namespace before reporting their
> > > > 	corresponding mount-ids. One downside of that approach is the
> > > > 	user will see an mount_id in the output with no corresponding
> > > > 	line to explain the details of the mount_id.  
> > > 
> > > Before the change, the peer and master ID's were basically randomly
> > > chosen from the peers, which means, it wasn't possible to always
> > > determine, that two mounts were peers, or that they were slaves to the
> > > same peer group.
> > > 
> > > After the change, this is possible, since the peer ID will be the same
> > > for all mounts which are peers.  This means, that even though the peer
> > > ID might be in a different namespace, it is possible to determine all
> > > peers within the same namespace by comparing their peer ID's.
> > 
> > 
> >  I agree with your reasoning on the random id; showing a single
> >  id avoids clutter. But my point is, why not show a
> >  id for the master or peer residing in the same namespace?
> 
> Because this way it is possible see propagation between different
> namespaces as well, by looking at the mount information for processes
> in the different namespaces.  Of course, this is only possible with
> sufficient privileges.

Gotta say I agree with Miklos this would be useful.  I'd far prefer to
see the id than a -1.

thanks,
-serge

> >  Showing a id with no corresponding entry for that id, can be
> >  intriguing.
> 
> Not if it's clearly documented (will add documentation for the next
> submission).
> 
> Miklos
> -
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
