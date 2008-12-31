Return-Path: <linux-kernel-owner+w=401wt.eu-S1756197AbYLaJrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbYLaJrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 04:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755147AbYLaJr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 04:47:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:33213 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbYLaJr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 04:47:28 -0500
Date: Wed, 31 Dec 2008 10:49:04 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: "Muntz, Daniel" <Dan.Muntz@netapp.com>
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       "Bernd Schubert" <bernd.schubert@fastmail.fm>, <nfsv4@linux-nfs.org>,
       <linux-kernel@vger.kernel.org>, <steved@redhat.com>,
       <dhowells@redhat.com>, <linux-next@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, <rwheeler@redhat.com>
Subject: Re: Pull request for FS-Cache, including NFS patches
Message-ID: <20081231104904.5a89fc60@infradead.org>
In-Reply-To: <7A24DF798E223B4C9864E8F92E8C93EC01AAFE66@SACMVEXC1-PRD.hq.netapp.com>
References: <1230662677.4952.37.camel@heimdal.trondhjem.org>
	<7A24DF798E223B4C9864E8F92E8C93EC01AAFE66@SACMVEXC1-PRD.hq.netapp.com>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008 14:15:42 -0800
"Muntz, Daniel" <Dan.Muntz@netapp.com> wrote:

> >> As for security, look at what MIT had to do to prevent local disk 
> >> caching from breaking the security guarantees of AFS.
> >
> >See what David has added to the LSM code to provide the same
> >guarantees
> for cachefs...
> >
> >Trond
> 
> Unless it (at least) leverages TPM, the issues I had in mind can't
> really be addressed in code.  One requirement is to prevent a local
> root user from accessing fs information without appropriate
> permissions. 

we're talking about NFS here (but also local CDs and potentially CIFS
etc). The level of security you're talking about is going to be the
same before or after cachefs.... very little against local root.

Frankly, any networking filesystem just trusts that the connection is
authenticated... eg there is SOMEONE on the machine who has the right
credentials. 

Cachefs doesn't change that; it still validates with the server before
giving userspace the data.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
