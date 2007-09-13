Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbXIMJW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbXIMJW5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755135AbXIMJWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:22:49 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43401 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbXIMJWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:22:48 -0400
Subject: Re: [PATCH] State limits to safety of _safe iterators
From: Matthew Helsley <matthltc@us.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070913010140.GA21306@linux.vnet.ibm.com>
References: <20070913010140.GA21306@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 02:22:45 -0700
Message-Id: <1189675366.5518.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-12 at 18:01 -0700, Paul E. McKenney wrote:
> The _safe list iterators make a blanket statement about how they are
> safe against removal.  This patch, inspired by private conversations
> with people who unwisely but perhaps understandably took this blanket
> statement at its word, adds comments stating limits to this safety.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  list.h |   42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff -urpNa -X dontdiff linux-2.6.22/include/linux/list.h linux-2.6.22-safedoc/include/linux/list.h
> --- linux-2.6.22/include/linux/list.h	2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22-safedoc/include/linux/list.h	2007-09-12 17:45:38.000000000 -0700
> @@ -472,6 +472,12 @@ static inline void list_splice_init_rcu(
>   * @pos:	the &struct list_head to use as a loop cursor.
>   * @n:		another &struct list_head to use as temporary storage
>   * @head:	the head for your list.
> + *
> + * Please note that this is safe only against removal by the code in

I'm not trying to be snarky but how far should we go before expecting
folks to read the macros? Depending on the answer you may also want to
mention that without additional additional code it's safe only against
removal of the list element at pos.

<snip>

Cheers,
	-Matt Helsley

