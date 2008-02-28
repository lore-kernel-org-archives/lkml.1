Return-Path: <linux-kernel-owner+w=401wt.eu-S932487AbYB1XI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbYB1XI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932101AbYB1XIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:08:17 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:42518 "EHLO zombie.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759020AbYB1XIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:08:16 -0500
Subject: Re: [PATCH 08/11] NFS: Introduce lifecycle management for label
	attribute.
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <Xine.LNX.4.64.0802290959120.15439@us.intercode.com.au>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204144786-3502-9-git-send-email-dpquigl@tycho.nsa.gov>
	 <Xine.LNX.4.64.0802281157170.27221@us.intercode.com.au>
	 <1204229267.24345.91.camel@moss-terrapins.epoch.ncsc.mil>
	 <Xine.LNX.4.64.0802290959120.15439@us.intercode.com.au>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 17:43:43 -0500
Message-Id: <1204238623.24345.128.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only benefit I can see for this is to make sure we don't leak any of
these labels. I can't find a reasonable way to match these up though so
it will just give us a hint that we are leaking something. 

Dave


On Fri, 2008-02-29 at 10:00 +1100, James Morris wrote:
> On Thu, 28 Feb 2008, Dave Quigley wrote:
> 
> > A question about the debug configuration here. Exactly what information
> > are we looking to get for debugging. If we want line/file/function that
> > these are called on then I need a macro wrapper for the allocation as
> > well. If that is the case I'm guessing we always define the macros
> > nfs_fattr_alloc and nfs_fattr_fini and just make the internal functions
> > static inline so they can be compiled away when !CONFIG_SECURITY.
> 
> Well, a WARN_ON will give you a stack trace.  It's up to you -- how much 
> debugging do you think this will need now? 
> 
> 
> - James

