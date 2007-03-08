Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbXCHAua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbXCHAua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXCHAu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:50:29 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:51664 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbXCHAu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:50:28 -0500
Message-ID: <45EF5D8F.6000309@us.ibm.com>
Date: Wed, 07 Mar 2007 18:49:19 -0600
From: Steve French <smfltc@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: remove useless cargo-cult checks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@lst.de> wrote on 03/07/2007 04:17:46 PM:
 > On Wed, Mar 07, 2007 at 12:51:04PM -0600, Steven French wrote:
 > > Is there an easy way to mirror particular patches going into the
 > > cifs-2.6.git tree (which is pulled into mm) to lkml?
 >  
 > Maybe some git expert can comment on that.
What I would be looking for is a way via e.g. "git commit" (to my 
project tree on kernel.org)
to pass it an option to send a copy of the patch to lkml or some list 
(or perhaps the reverse,
set a flag that says don't bother mirroring patch for review to fsdevel 
or lkml).  With Samba,
some people just watch all commits, but for the kernel that is way too many.

 
 > > The cifs patches go in mm for at least a week before they go into 
kernel
 > > but some of them I would like to post again to lkml.
 >  
 > polling -mm is a little hard as it's an enormous blob, so posting to
 > lkml or -fsdevel would definitively be quite helpfull.

Yes agreed (watching fsdevel is easier than scanning every new -mm 
patch) - but I would rather not
bore people, and make them waste time on fsdevel or lkml looking at 
every single cifs patch.  Only about
three of the past 10 cifs patches were interesting enough to ask for 
detailed review (and I would
have loved an easier way to get review on those - as I would love to get 
more review of
Q's interesting DFS patch - but it is hard in practice to make this easy).
