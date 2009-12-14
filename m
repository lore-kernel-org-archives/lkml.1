Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbZLNOHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbZLNOHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbZLNOHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:07:00 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:54855 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbZLNOG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:06:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=U1CBbFLME57a4yCgkZG035ac+qZkcstm5kNxgfnlf0nuSLmx6gqWAgqHftMvyWCFgd
         wbPqbNXAt7FUQPgFpgHdiv50kCI7BVhp8m/92EjDrpdRCKjYTBk17YTacc0tyC+z1fca
         YmcWwIsu7AWPZ8seMnym11DAUf8eYwyWDkzzM=
Date: Mon, 14 Dec 2009 15:06:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix no-hardware-breakpoint case
Message-ID: <20091214140652.GM5168@nowhere>
References: <20091214140326.11689.80251.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214140326.11689.80251.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 02:03:27PM +0000, David Howells wrote:
> If there is no hardware breakpoint support, modify_user_hw_breakpoint() tries
> to return a NULL pointer through as an 'int' return value:
> 
> In file included from kernel/exit.c:53:
> include/linux/hw_breakpoint.h: In function 'modify_user_hw_breakpoint':
> include/linux/hw_breakpoint.h:96: warning: return makes integer from pointer without a cast
> 
> Return 0 instead.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>


Thanks, we have this fixed in tip:/perf/urgent already. It should
reach upstream soon.

