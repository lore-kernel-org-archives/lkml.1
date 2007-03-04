Return-Path: <linux-kernel-owner+w=401wt.eu-S1752406AbXCDSy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406AbXCDSy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 13:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbXCDSy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 13:54:28 -0500
Received: from eldorado.sekrit.org ([72.5.28.212]:60918 "EHLO
	eldorado.sekrit.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbXCDSy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 13:54:27 -0500
X-Greylist: delayed 4872 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Mar 2007 13:54:27 EST
Date: Sun, 4 Mar 2007 12:33:10 -0500
From: Gerald Britton <gbritton@doomcom.org>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] [RSDL 1/6] lists: add list splice tail
Message-ID: <20070304173310.GA20939@zante.sekrit.org>
References: <200703041802.13991.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703041802.13991.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 06:02:13PM +1100, Con Kolivas wrote:
> Add a list_splice_tail variant of list_splice.
> 
> Patch-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Con Kolivas <kernel@kolivas.org>
...
> @@ -360,6 +386,22 @@ static inline void list_splice_init(stru
>  }
>  
>  /**
> + * list_splice_init - join two lists at one's tail and reinitialise emptied

You should update the comment to match the function.

				-- Gerald

> + * @list: the new list to add.
> + * @head: the place to add it in the first list.
> + *
> + * The list at @list is reinitialised
> + */
> +static inline void list_splice_tail_init(struct list_head *list,
> +					 struct list_head *head)
