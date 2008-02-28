Return-Path: <linux-kernel-owner+w=401wt.eu-S1761456AbYB1XBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761456AbYB1XBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 18:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758612AbYB1XA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 18:00:59 -0500
Received: from namei.org ([69.55.235.186]:37407 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758574AbYB1XA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 18:00:58 -0500
Date: Fri, 29 Feb 2008 10:00:12 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Dave Quigley <dpquigl@tycho.nsa.gov>
cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 08/11] NFS: Introduce lifecycle management for label
 attribute.
In-Reply-To: <1204229267.24345.91.camel@moss-terrapins.epoch.ncsc.mil>
Message-ID: <Xine.LNX.4.64.0802290959120.15439@us.intercode.com.au>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov> 
 <1204144786-3502-9-git-send-email-dpquigl@tycho.nsa.gov> 
 <Xine.LNX.4.64.0802281157170.27221@us.intercode.com.au>
 <1204229267.24345.91.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Dave Quigley wrote:

> A question about the debug configuration here. Exactly what information
> are we looking to get for debugging. If we want line/file/function that
> these are called on then I need a macro wrapper for the allocation as
> well. If that is the case I'm guessing we always define the macros
> nfs_fattr_alloc and nfs_fattr_fini and just make the internal functions
> static inline so they can be compiled away when !CONFIG_SECURITY.

Well, a WARN_ON will give you a stack trace.  It's up to you -- how much 
debugging do you think this will need now? 


- James
-- 
James Morris
<jmorris@namei.org>
