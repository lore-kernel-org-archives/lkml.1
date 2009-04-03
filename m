Return-Path: <linux-kernel-owner+w=401wt.eu-S1764490AbZDCM21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764490AbZDCM21 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 08:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761142AbZDCM2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 08:28:12 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:51807 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757175AbZDCM2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 08:28:11 -0400
Subject: Re: [PATCH 08/14] NFSv4: Add label recommended attribute and NFSv4
 flags
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: casey@schaufler-ca.com, sds@tycho.nsa.gov,
       "Matthew N. Dodd" <matthew.dodd@sparta.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
In-Reply-To: <alpine.LRH.2.00.0904032239330.16607@tundra.namei.org>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1227733394-1114-9-git-send-email-dpquigl@tycho.nsa.gov>
	 <alpine.LRH.2.00.0904031921320.11240@tundra.namei.org>
	 <1238752770.7541.58.camel@moss-terrapins.epoch.ncsc.mil>
	 <alpine.LRH.2.00.0904032239330.16607@tundra.namei.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 03 Apr 2009 08:23:44 -0400
Message-Id: <1238761424.7541.68.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 22:43 +1100, James Morris wrote:
> On Fri, 3 Apr 2009, David P. Quigley wrote:
> 
> > We tried to change this to be dynamically allocated based on what was
> > coming off of the wire but we ran into a problem that it required us to
> > do allocations where they really shouldn't be done in the rpc/nfsv4
> > code. Trond suggested to make this static and that if someone really
> > needed more than a page for their label that something was horrifically
> > wrong. I'm tempted to agree with him on this but there are people trying
> > to send contexts with an MLS component with every other compartment set
> > which tend to be really large. 
> 
> Well, future labels might include cryptographic information, for example.
> 

<removing people from the CC who probably don't care about this>

Could you expand on why this might be needed or what applications would
use this? It's unclear to me what sort of crypto information would be in
a context. I know the ecryptfs guys were trying to make crypto decisions
based on SELinux context in some cases but I never heard of wanting to
put that kind of information into the context.

Dave

