Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214Ab0AELbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0AELbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 06:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395Ab0AELbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 06:31:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43040 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0AELbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 06:31:17 -0500
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, Artem Bityutskiy <dedekind@infradead.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH] sort: Introduce generic list_sort function
From: Andi Kleen <andi@firstfloor.org>
References: <1262649295-28427-1-git-send-email-david__25057.2445955642$1262651404$gmane$org@fromorbit.com>
Date: Tue, 05 Jan 2010 12:31:15 +0100
In-Reply-To: <1262649295-28427-1-git-send-email-david__25057.2445955642$1262651404$gmane$org@fromorbit.com> (Dave Chinner's message of "Tue,  5 Jan 2010 10:54:55 +1100")
Message-ID: <87eim4dbzw.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:
> +
> +/**
> + * list_sort - sort a list.
> + * @priv: private data, passed to @cmp
> + * @head: the list to sort
> + * @cmp: the elements comparison function
> + *
> + * This function has been implemented by Mark J Roberts <mjr@znex.org>. It
> + * implements "merge sort" which has O(nlog(n)) complexity. The list is sorted
> + * in ascending order.
> + *
> + * The comparison function @cmp is supposed to return a negative value if @a is
> + * than @b, and a positive value if @a is greater than @b. If @a and @b are
> + * equivalent, then it does not matter what this function returns.
> + */
> +void list_sort(void *priv, struct list_head *head,
> +	       int (*cmp)(void *priv, struct list_head *a,
> +			  struct list_head *b))

No EXPORT_SYMBOL? 

Also it would seem cleaner to have it in a own file.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
