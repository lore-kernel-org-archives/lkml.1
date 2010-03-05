Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab0CESC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:02:58 -0500
Received: from mx2.netapp.com ([216.240.18.37]:54066 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581Ab0CESC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:02:57 -0500
X-IronPort-AV: E=Sophos;i="4.49,588,1262592000"; 
   d="scan'208";a="326750063"
Subject: Re: Merge of the 'write_inode' branch from the VFS tree
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100305154823.GV30031@ZenIV.linux.org.uk>
References: <1267802800.5174.6.camel@localhost.localdomain>
	 <20100305154823.GV30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Fri, 05 Mar 2010 13:02:35 -0500
Message-ID: <1267812155.5174.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
X-OriginalArrivalTime: 05 Mar 2010 18:02:36.0186 (UTC) FILETIME=[095BA7A0:01CABC8E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 15:48 +0000, Al Viro wrote:

> Or I can do a new branch, put updated pair of patches there (hch has sent
> the updated variants my way) and ask you to rebuild NFS tree.  Which will
> also suck, since it adds PITA for you and you are completely innocent in
> that clusterfuck.
> 
> Suggestions?  I'd love to get out of that mess with minimal PITA for
> everyone involved and minimally messed tree...

Hi Al,

I'd be fine with rebuilding the NFS tree. I have all the patches which
depend on write_inode in their own separate branch anyway, so I'd only
have to rebase that branch and then merge it with the main NFS client
tree...

Cheers
  Trond
