Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbYJNOs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbYJNOs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYJNOsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:48:17 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:62398 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbYJNOsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:48:16 -0400
Subject: Re: [Labeled-nfs] [RFC v3] Security Label Support for NFSv4
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "Matthew N. Dodd" <Matthew.Dodd@sparta.com>,
       James Morris <jmorris@namei.org>, labeled-nfs@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
       selinux@tycho.nsa.gov
In-Reply-To: <1223990448.8907.1.camel@localhost>
References: <1222707986-26606-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <alpine.LRH.1.10.0810141014580.26030@tundra.namei.org>
	 <48F400DD.50905@sparta.com>  <1223990448.8907.1.camel@localhost>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 10:28:44 -0400
Message-Id: <1223994524.3791.57.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-14 at 09:20 -0400, Trond Myklebust wrote:
> On Mon, 2008-10-13 at 22:15 -0400, Matthew N. Dodd wrote:
> > James Morris wrote:
> > > On Mon, 29 Sep 2008, David P. Quigley wrote:
> > > 
> > >> 	* New security flavor (auth_seclabel) to transport process label to
> > >> 	  server. This is a derivative of auth_unix so it does not support
> > >> 	  kerberos which has its own issues that need to be dealt with.
> > > 
> > > This is a problem, as discussed last year:
> > > 
> > > http://linux-nfs.org/pipermail/labeled-nfs/2007-November/000110.html
> > > 
> > > We can't require the use of a new auth flavor which is incompatible with 
> > > auth_gss.
> > 
> > auth_seclabel demonstrates the flavor independent changes required for 
> > any RPC layer process label transport.  A GSS solution is currently 
> > under discussion.
> 
> Right, but I'm not particularly interested in merging "demonstration"
> code that might end up requiring permanent support. I'd very much like
> to see all of this get further through the IETF process before we talk
> about merging into mainline.
> 
> Cheers
>   Trond

Hello,
    Nico seems to have come up with a reasonable solution for this
problem we just need to sit down and draw up a document for it.
Apparently he already created a mechanism in rpcsec_gss for allowing you
to bind the rpc session to more than just the normal credentials. Once
we finalize this and get it into a draft we will work on implementing it
in the rpcsec_gss auth flavor.

Dave

