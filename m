Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760061AbYLQHzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbYLQHzE (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 02:55:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbYLQHyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 02:54:53 -0500
Received: from tundra.namei.org ([65.99.196.166]:4869 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYLQHyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 02:54:52 -0500
Date: Wed, 17 Dec 2008 18:54:37 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] audit: validate comparison operations, store them
 in sane form
In-Reply-To: <E1LCoiw-0000Gw-Ud@ZenIV.linux.org.uk>
Message-ID: <alpine.LRH.1.10.0812171854220.22856@tundra.namei.org>
References: <E1LCoiw-0000Gw-Ud@ZenIV.linux.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2008, Al Viro wrote:

> 
> Don't store the field->op in the messy (and very inconvenient for e.g.
> audit_comparator()) form; translate to dense set of values and do full
> validation of userland-submitted value while we are at it.
> 
> ->audit_init_rule() and ->audit_match_rule() get new values now; in-tree
> instances updated.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
