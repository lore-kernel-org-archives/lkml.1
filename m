Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbYHANQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbYHANQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYHANQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:16:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40801 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751442AbYHANQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:16:41 -0400
Date: Fri, 1 Aug 2008 08:16:36 -0500
From: Jack Steiner <steiner@sgi.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 31 (GRU build error)
Message-ID: <20080801131636.GA4023@sgi.com>
References: <20080731175854.09ea35c8.sfr@canb.auug.org.au> <20080731223758.b5985dd7.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731223758.b5985dd7.randy.dunlap@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 10:37:58PM -0700, Randy Dunlap wrote:
> 
> xp_uv.c:(.text+0x4186b): undefined reference to `gru_copy_gpa'
> xpc_uv.c:(.text+0x44616): undefined reference to `gru_create_message_queue'
> xpc_uv.c:(.text+0x44e16): undefined reference to `gru_free_message'
> xpc_uv.c:(.text+0x44e22): undefined reference to `gru_get_next_message'
> xpc_uv.c:(.text+0x44e67): undefined reference to `gru_send_message_gpa'
> xpc_uv.c:(.text+0x45a79): undefined reference to `gru_free_message'
> xpc_uv.c:(.text+0x45a85): undefined reference to `gru_get_next_message'
> make[1]: *** [.tmp_vmlinux1] Error 1

This is not actually a GRU problem. XP is missing a dependency. Dean will
post a patch later today.


> 
> 
> config attached.
> 
> 
> and please add a GRU maintainer entry somewhere.
 
Done. Also added maintainer for XP...

--- jack
