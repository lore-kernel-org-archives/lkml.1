Return-Path: <linux-kernel-owner+w=401wt.eu-S1757936AbYFIAMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbYFIAMs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 20:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYFIAMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 20:12:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574AbYFIAMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 20:12:38 -0400
Date: Sun, 8 Jun 2008 17:12:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dean Nelson <dcn@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 03/18] define BYTES_PER_WORD
Message-Id: <20080608171235.5e1bba29.akpm@linux-foundation.org>
In-Reply-To: <20080606164455.GD13695@sgi.com>
References: <20080606164034.GA13695@sgi.com>
	<20080606164455.GD13695@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 11:44:55 -0500 Dean Nelson <dcn@sgi.com> wrote:

> Add a BYTES_PER_WORD #define.
> 
> Signed-off-by: Dean Nelson <dcn@sgi.com>
> 
> ---
> 
>  drivers/misc/sgi-xp/xp.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6/drivers/misc/sgi-xp/xp.h
> ===================================================================
> --- linux-2.6.orig/drivers/misc/sgi-xp/xp.h	2008-05-30 13:59:29.580809165 -0500
> +++ linux-2.6/drivers/misc/sgi-xp/xp.h	2008-05-30 14:00:00.200614111 -0500
> @@ -19,6 +19,9 @@
>  #include <asm/sn/types.h>
>  #include <asm/sn/bte.h>
>  
> +/* >>> Add this #define to some linux header file some day. */

The patches fill the code with this ">>>" string - which can cause
false positives when people are searching for git rejects.  Although I
(and I suspect most other people) search for "<<<<<<<".

> +#define BYTES_PER_WORD	sizeof(void *)

Dunno if this is a desirable thing to have, really.  A "word" is a
somewhat ill-defined thing.  The definition you have here is always
equal to BYTES_PER_LONG.  If BYTES_PER_LONG is inappropriate then
BYTES_PER_POINTER would be clearer.


