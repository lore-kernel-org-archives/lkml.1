Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbYDCXF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbYDCXF3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 19:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYDCXFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 19:05:18 -0400
Received: from namei.org ([69.55.235.186]:47999 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751495AbYDCXFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 19:05:16 -0400
Date: Fri, 4 Apr 2008 10:02:39 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Stephen Smalley <sds@tycho.nsa.gov>
cc: Andrew Morton <akpm@linux-foundation.org>, Josef Bacik <jbacik@redhat.com>,
       Valdis.Kletnieks@vt.edu, sct@redhat.com, jack@suse.cz,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       eparis@redhat.com
Subject: Re: 2.6.25-rc8-mm1 - BUG in fs/jbd/transaction.c
In-Reply-To: <1207246695.27710.292.camel@moss-spartans.epoch.ncsc.mil>
Message-ID: <Xine.LNX.4.64.0804041001410.23232@us.intercode.com.au>
References: <20080401213214.8fbb6d6b.akpm@linux-foundation.org> 
 <6495.1207163569@turing-police.cc.vt.edu>  <20080402192715.GA32454@unused.rdu.redhat.com>
  <20080402123905.386c56f8.akpm@linux-foundation.org>
 <1207246695.27710.292.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Stephen Smalley wrote:

> > > Try this patch, it will keep us from re-entering the fs when we aren't supposed
> > > to.  cc'ing Eric Paris since he's the only selinux guy I know :).  I don't think

Please see the MAINTAINERS file.

> > > any of the other allocations in here need to be fixed, but I didn't look too
> > > carefully.
> > > 
> > > Signed-off-by: Josef Bacik <jbacik@redhat.com>

Thanks, I'll push this to Linus, but note that further analysis is 
required.


-- 
James Morris
<jmorris@namei.org>
