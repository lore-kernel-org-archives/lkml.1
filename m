Return-Path: <linux-kernel-owner+w=401wt.eu-S965280AbXDKURl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965280AbXDKURl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965275AbXDKURl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:17:41 -0400
Received: from mail.fieldses.org ([66.93.2.214]:45247 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964989AbXDKURk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:17:40 -0400
Date: Wed, 11 Apr 2007 16:17:36 -0400
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 8/8] AFS: Add security support
Message-ID: <20070411201736.GD3704@fieldses.org>
References: <20070411193844.GC3704@fieldses.org> <20070411190956.15499.55352.stgit@warthog.cambridge.redhat.com> <20070411191037.15499.67852.stgit@warthog.cambridge.redhat.com> <18379.1176322232@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18379.1176322232@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 09:10:32PM +0100, David Howells wrote:
> J. Bruce Fields <bfields@fieldses.org> wrote:
> 
> > Just curious--when is the actual crypto done?  There doesn't seem to be
> > any in this patch.
> 
> See AF_RXRPC patch:
> 
> 	http://people.redhat.com/~dhowells/rxrpc/04-af_rxrpc.diff
> 
> You turn on CONFIG_RXKAD and load the rxkad module thus built (assuming you
> haven't built it in) after loading the af_rxrpc module.  I probably should've
> mentioned that in the cover.

Oh, I see--didn't think to check net/rxrpc.  Thanks!

--b.
