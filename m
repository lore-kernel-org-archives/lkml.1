Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759647AbYLQJdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759647AbYLQJdH (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYLQJcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:32:55 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51150 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYLQJcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:32:54 -0500
Date: Wed, 17 Dec 2008 09:32:45 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Morris <jmorris@namei.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/15] sanitize audit_ipc_obj()
Message-ID: <20081217093245.GC28946@ZenIV.linux.org.uk>
References: <E1LCoh0-00009T-Sd@ZenIV.linux.org.uk> <alpine.LRH.1.10.0812171823430.22856@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0812171823430.22856@tundra.namei.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 06:24:40PM +1100, James Morris wrote:
> On Wed, 17 Dec 2008, Al Viro wrote:
> 
> > +		struct {
> > +			uid_t			uid;
> > +			gid_t			gid;
> > +			mode_t			mode;
> > +			u32			osid;
> > +		} ipc;
> 
> 'osid' should be converted into 'secid' someday.

Eh?  Do you mean the field name there or the actual output?  Either is
trivial, of course, but the latter is up to userland folks and the
former alone seems to be rather pointless...
