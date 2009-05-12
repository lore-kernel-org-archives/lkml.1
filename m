Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZELWmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZELWmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbZELWmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:42:45 -0400
Received: from mx2.netapp.com ([216.240.18.37]:7337 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980AbZELWmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:42:44 -0400
X-IronPort-AV: E=Sophos;i="4.41,184,1241420400"; 
   d="scan'208";a="171203480"
Subject: Re: [stable] [PATCH] NFS: Fix the notifications when renaming onto
 an existing file
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Greg KH <greg@kroah.com>
Cc: stable@kernel.org, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090512223105.GA16679@kroah.com>
References: <20090512222420.6972.25308.stgit@heimdal.trondhjem.org>
	 <20090512223105.GA16679@kroah.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 12 May 2009 18:42:40 -0400
Message-Id: <1242168160.5407.18.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 12 May 2009 22:42:45.0271 (UTC) FILETIME=[F7AABA70:01C9D352]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-12 at 15:31 -0700, Greg KH wrote:
> On Tue, May 12, 2009 at 06:24:20PM -0400, Trond Myklebust wrote:
> > NFS appears to be returning an unnecessary "delete" notification when
> > we're doing an atomic rename. See
> > 
> >   http://bugzilla.gnome.org/show_bug.cgi?id=575684
> > 
> > The fix is to get rid of the redundant call to d_delete().
> > 
> > Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > ---
> > Please apply to 2.6.27 - 2.6.29 stable series...
> 
> Is this already in Linus's tree?  If so, what is the git commit id?

Sorry, I forgot to include that. The commit id in mainline is
b1e4adf4ea41bb8b5a7bfc1a7001f137e65495df.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
