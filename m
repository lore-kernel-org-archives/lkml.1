Return-Path: <linux-kernel-owner+w=401wt.eu-S1764253AbZDCLoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764253AbZDCLoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761822AbZDCLnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:43:50 -0400
Received: from tundra.namei.org ([65.99.196.166]:4085 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831AbZDCLns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:43:48 -0400
Date: Fri, 3 Apr 2009 22:43:15 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@zeniv.linux.org.uk, casey@schaufler-ca.com,
       sds@tycho.nsa.gov, "Matthew N. Dodd" <matthew.dodd@sparta.com>,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       labeled-nfs@linux-nfs.org
Subject: Re: [PATCH 08/14] NFSv4: Add label recommended attribute and NFSv4
 flags
In-Reply-To: <1238752770.7541.58.camel@moss-terrapins.epoch.ncsc.mil>
Message-ID: <alpine.LRH.2.00.0904032239330.16607@tundra.namei.org>
References: <1227733394-1114-1-git-send-email-dpquigl@tycho.nsa.gov>  <1227733394-1114-9-git-send-email-dpquigl@tycho.nsa.gov>  <alpine.LRH.2.00.0904031921320.11240@tundra.namei.org> <1238752770.7541.58.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, David P. Quigley wrote:

> We tried to change this to be dynamically allocated based on what was
> coming off of the wire but we ran into a problem that it required us to
> do allocations where they really shouldn't be done in the rpc/nfsv4
> code. Trond suggested to make this static and that if someone really
> needed more than a page for their label that something was horrifically
> wrong. I'm tempted to agree with him on this but there are people trying
> to send contexts with an MLS component with every other compartment set
> which tend to be really large. 

Well, future labels might include cryptographic information, for example.

-- 
James Morris
<jmorris@namei.org>
