Return-Path: <linux-kernel-owner+w=401wt.eu-S1751161AbXBMHhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbXBMHhn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 02:37:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbXBMHhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 02:37:43 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:1207 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbXBMHhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 02:37:42 -0500
Date: Tue, 13 Feb 2007 09:37:38 +0200
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Coding style RFC: convert "for (i=0;i<ARRAY_SIZE(array);i++)" to "array_for_each(index, array)"
Message-ID: <20070213073738.GB23804@rhun.ibm.com>
References: <1171324070.1528.25.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1171324070.1528.25.camel@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 03:47:50PM -0800, Joe Perches wrote:

> Now that most of the sizeof(array)/sizeof(array[0]) conversions have
> been done (there are about 800 done and about another 130 left),
> perhaps it could be useful to change the code to use a define
> similar to the list_for_each
> 
> #define list_for_each(pos, head) \
> 	for (pos = (head)->next; prefetch(pos->next), pos != (head); \
>         	pos = pos->next)
> 
> perhaps
> 
> #define array_for_each(index, array) \
> 	for ((index) = 0; (index) < ARRAY_SIZE((array)); (index)++)

Could we please stop "improving" the C language? it has served us fine
so far.

Cheers,
Muli
