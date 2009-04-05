Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbZDEXeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbZDEXeG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 19:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbZDEXdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 19:33:54 -0400
Received: from tundra.namei.org ([65.99.196.166]:3894 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbZDEXdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 19:33:53 -0400
Date: Mon, 6 Apr 2009 09:33:16 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: casey@schaufler-ca.com, sds@tycho.nsa.gov,
       "Matthew N. Dodd" <matthew.dodd@sparta.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 08/14] NFSv4: Add label recommended attribute and NFSv4
 flags
In-Reply-To: <1238761424.7541.68.camel@moss-terrapins.epoch.ncsc.mil>
Message-ID: <alpine.LRH.2.00.0904060931530.3712@tundra.namei.org>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>  <1227733394-1114-9-git-send-email-dpquigl@tycho.nsa.gov>  <alpine.LRH.2.00.0904031921320.11240@tundra.namei.org>  <1238752770.7541.58.camel@moss-terrapins.epoch.ncsc.mil> 
 <alpine.LRH.2.00.0904032239330.16607@tundra.namei.org> <1238761424.7541.68.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, David P. Quigley wrote:

> On Fri, 2009-04-03 at 22:43 +1100, James Morris wrote:
> > On Fri, 3 Apr 2009, David P. Quigley wrote:
> > 
> > > We tried to change this to be dynamically allocated based on what was
> > > coming off of the wire but we ran into a problem that it required us to
> > > do allocations where they really shouldn't be done in the rpc/nfsv4
> > > code. Trond suggested to make this static and that if someone really
> > > needed more than a page for their label that something was horrifically
> > > wrong. I'm tempted to agree with him on this but there are people trying
> > > to send contexts with an MLS component with every other compartment set
> > > which tend to be really large. 
> > 
> > Well, future labels might include cryptographic information, for example.
> > 
> 
> <removing people from the CC who probably don't care about this>
> 
> Could you expand on why this might be needed or what applications would
> use this? It's unclear to me what sort of crypto information would be in
> a context. I know the ecryptfs guys were trying to make crypto decisions
> based on SELinux context in some cases but I never heard of wanting to
> put that kind of information into the context.

Potentially as part of a mandatory cryptographic policy, although the 
exact form of the labeling is unknown.

But the main point is that we should not needlessly limit the flexibility 
of the system.

-- 
James Morris
<jmorris@namei.org>
