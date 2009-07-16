Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZGPEfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZGPEfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZGPEfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:35:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50698 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbZGPEfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:35:40 -0400
Date: Wed, 15 Jul 2009 21:35:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/3] Rename pgmoved variable in shrink_active_list()
Message-Id: <20090715213516.9b47ad16.akpm@linux-foundation.org>
In-Reply-To: <20090716131928.9D25.A69D9226@jp.fujitsu.com>
References: <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
	<20090715201654.550cb640.akpm@linux-foundation.org>
	<20090716131928.9D25.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009 13:22:30 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> -#define __add_zone_page_state(__z, __i, __d)	\
> -		__mod_zone_page_state(__z, __i, __d)
> -#define __sub_zone_page_state(__z, __i, __d)	\
> -		__mod_zone_page_state(__z, __i,-(__d))
> -

yeah, whatever, I don't think they add a lot of value personally.

I guess they're a _bit_ clearer than doing __sub_zone_page_state() with
a negated argument.  Shrug.
