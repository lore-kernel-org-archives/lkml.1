Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbZKTLQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbZKTLQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 06:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbZKTLQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 06:16:42 -0500
Received: from fogou.chygwyn.com ([195.171.2.24]:45117 "EHLO fogou.chygwyn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbZKTLQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 06:16:42 -0500
X-Greylist: delayed 3095 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Nov 2009 06:16:41 EST
Date: Fri, 20 Nov 2009 09:19:56 +0000
From: steve@chygwyn.com
To: David Howells <dhowells@redhat.com>
Cc: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, steved@redhat.com
Subject: Re: [PATCH 01/28] SLOW_WORK: Wait for outstanding work items
	belonging to  a module to clear
Message-ID: <20091120091956.GA11493@fogou.chygwyn.com>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk> <20091119172039.1679.7892.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091119172039.1679.7892.stgit@warthog.procyon.org.uk>
Organization: ChyGwyn Limited
X-Registered-Office: Digital Technium, Singleton Park, Swansea. SA2 8PP
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 19, 2009 at 05:20:39PM +0000, David Howells wrote:
> Wait for outstanding slow work items belonging to a module to clear when
> unregistering that module as a user of the facility.  This prevents the put_ref
> code of a work item from being taken away before it returns.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  Documentation/slow-work.txt |   13 +++-
>  fs/fscache/main.c           |    6 +-
>  fs/fscache/object.c         |    1 
>  fs/fscache/operation.c      |    1 
>  fs/gfs2/main.c              |    4 +
>  fs/gfs2/recovery.c          |    1 
>  include/linux/slow-work.h   |    8 ++-
>  kernel/slow-work.c          |  132 +++++++++++++++++++++++++++++++++++++++++--
>  8 files changed, 150 insertions(+), 16 deletions(-)
>
GFS2 bits Acked-By: Steven Whitehouse <swhiteho@redhat.com>

Steve.
