Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbYDDP3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbYDDP3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbYDDP3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:29:41 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:50890 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817AbYDDP3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:29:40 -0400
Subject: Re: [TOMOYO #7 02/30] Internal functions prototypes for SAKURA and
	TOMOYO.
From: Daniel Walker <dwalker@mvista.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
In-Reply-To: <20080404122357.420668479@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
	 <20080404122357.420668479@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 08:29:32 -0700
Message-Id: <1207322973.21308.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-04 at 21:22 +0900, Tetsuo Handa wrote:
> +/**
> + * list1_entry - get the struct for this entry
> + * @ptr:        the &struct list1_head pointer.
> + * @type:       the type of the struct this is embedded in.
> + * @member:     the name of the list1_struct within the struct.
> + */
> +#define list1_entry(ptr, type, member) container_of(ptr, type,
> member)
> +
> +/**
> + * list1_for_each        -       iterate over a list
> + * @pos:        the &struct list1_head to use as a loop cursor.
> + * @head:       the head for your list.
> + */
> +#define list1_for_each(pos,
> head)                                      \
> +       for (pos = (head)->next; prefetch(pos->next), pos !=
> (head);    \
> +            pos = pos->next)
> +

These should go into include/linux/list.h .. It looks like you are
duplicate at least some of what is already in there..

Daniel

