Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759969AbYLQJyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969AbYLQJyd (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbYLQJyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:54:23 -0500
Received: from tundra.namei.org ([65.99.196.166]:4302 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbYLQJyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:54:22 -0500
Date: Wed, 17 Dec 2008 20:53:04 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Al Viro <viro@ftp.linux.org.uk>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/15] sanitize audit_ipc_obj()
In-Reply-To: <20081217093245.GC28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.1.10.0812172047090.24405@tundra.namei.org>
References: <E1LCoh0-00009T-Sd@ZenIV.linux.org.uk> <alpine.LRH.1.10.0812171823430.22856@tundra.namei.org> <20081217093245.GC28946@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Al Viro wrote:

> On Wed, Dec 17, 2008 at 06:24:40PM +1100, James Morris wrote:
> > On Wed, 17 Dec 2008, Al Viro wrote:
> > 
> > > +		struct {
> > > +			uid_t			uid;
> > > +			gid_t			gid;
> > > +			mode_t			mode;
> > > +			u32			osid;
> > > +		} ipc;
> > 
> > 'osid' should be converted into 'secid' someday.
> 
> Eh?  Do you mean the field name there or the actual output?  Either is
> trivial, of course, but the latter is up to userland folks and the
> former alone seems to be rather pointless...

I was thinking in terms of the kernel API, where 'secid' is the preferred 
name for security identifiers ('sid' being an SELinux-specific term and 
also conflicting with 'session id').  Given that it's exposed to userland, 
I guess it's too late.


- James
-- 
James Morris
<jmorris@namei.org>
