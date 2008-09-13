Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbYIMAQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbYIMAQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 20:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYIMAQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 20:16:14 -0400
Received: from tundra.namei.org ([65.99.196.166]:41400 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbYIMAQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 20:16:13 -0400
Date: Sat, 13 Sep 2008 10:15:43 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       sds@tycho.nsa.gov
Subject: Re: [Bug #11500] /proc/net bug related to selinux
In-Reply-To: <20080912152443.c4e59f42.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.1.10.0809131012310.13073@tundra.namei.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.i9G.ZcsyIB@albercik> <alpine.LRH.1.10.0809130812460.12313@tundra.namei.org> <20080912152443.c4e59f42.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008, Andrew Morton wrote:

> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11500
> > > Subject		: /proc/net bug related to selinux
> > > Submitter	: Andrew Morton <akpm@linux-foundation.org>
> > > Date		: 2008-09-04 17:45 (9 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=122055041313270&w=4
> > 
> > I think this might be a regression caused by namespace changes which we 

By which I mean, this was caused by a non-SELinux change to the upstream 
kernel many, many eons ago.

> > addressed in SELinux policy.  Which distro version & policy version is 
> > this seen with?
> > 
> 
> FC5 on x86_32 and FC6 on x86_64.

As mentioned in the bugzilla, any related avc messages would be useful.


-- 
James Morris
<jmorris@namei.org>
