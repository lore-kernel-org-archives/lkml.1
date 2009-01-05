Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZAEWXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZAEWXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 17:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZAEWXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 17:23:31 -0500
Received: from tundra.namei.org ([65.99.196.166]:4439 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbZAEWXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 17:23:30 -0500
Date: Tue, 6 Jan 2009 09:22:42 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
cc: bfields@fieldses.org, hch@lst.de, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix NFSD regression
In-Reply-To: <20090105171937.4463.98583.stgit@warthog.procyon.org.uk>
Message-ID: <alpine.LRH.1.10.0901060922210.20738@tundra.namei.org>
References: <806.1231174132@redhat.com> <20090105171937.4463.98583.stgit@warthog.procyon.org.uk>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, David Howells wrote:

> Fix a regression in NFSD's permission checking introduced by the credentials
> patches.  There are two parts to the problem, both in nfsd_setuser():
> 
>  (1) The return value of set_groups() is -ve if in error, not 0, and should be
>      checked appropriately.  0 indicates success.
> 
>  (2) The UID to use for fs accesses is in new->fsuid, not new->uid (which is
>      0).  This causes CAP_DAC_OVERRIDE to always be set, rather than being
>      cleared if the UID is anything other than 0 after squashing.
> 
> Reported-by: J. Bruce Fields <bfields@fieldses.org>
> Signed-off-by: David Howells <dhowells@redhat.com>

Acked-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
