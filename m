Return-Path: <linux-kernel-owner+w=401wt.eu-S1750811AbXBWDei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750811AbXBWDei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 22:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750812AbXBWDei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 22:34:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbXBWDeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 22:34:37 -0500
Message-ID: <45DE60C1.2020103@redhat.com>
Date: Thu, 22 Feb 2007 22:34:25 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: 7eggert@gmx.de
CC: Christoph Lameter <clameter@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] free swap space when (re)activating page
References: <7Pk3X-bD-17@gated-at.bofh.it> <7QvgM-3aK-3@gated-at.bofh.it> <7QDeB-7KY-11@gated-at.bofh.it> <7QGc7-3ZB-13@gated-at.bofh.it> <7QGlP-4e1-11@gated-at.bofh.it> <7QHUO-6RS-5@gated-at.bofh.it> <7QJ9Y-mo-1@gated-at.bofh.it> <7QJk7-zW-51@gated-at.bofh.it> <E1HKPTs-0005p5-IV@be1.lrz>
In-Reply-To: <E1HKPTs-0005p5-IV@be1.lrz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> Rik van Riel <riel@redhat.com> wrote:
> 
> +++ linux-2.6.20.noarch/mm/swap.c        2007-02-20 06:44:17.000000000 -0500
> @@ -420,6 +420,26 @@ void pagevec_strip(struct pagevec *pvec)
> 
>> +                        if (printk_ratelimit())
>> +                                printk("kswapd freed a swap space\n");
>>
> 
> NOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO!!!!!!!!!!!
> 
> 1) This message is a debug message! You forgot to set the printk level.

Doh, I forgot to cut it out of the patch when I fixed it
according to Christoph's hint.

This chunk should be removed from the patch...

Andrew, I'll send you a new one tomorrow morning.

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
