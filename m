Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbZGIKU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbZGIKU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbZGIKUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:20:49 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:60053 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZGIKUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:20:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rEKExYLwL1Apj9/a3PDR9eq0YivDshAS4byEV5v6UctS05OjrsVF16SMRL3H4YgKvI
         AoHC+97U3k4gg8LDhBRQ4Av6oSvo7/K0kewV/rvJXLj4uHWDMgl9Gd1+Th1+dWWLMfeg
         flfLnL+YABB4mITuxLz4u+5RmPfYJ9/aUuzTY=
MIME-Version: 1.0
In-Reply-To: <20090709171122.23C3.A69D9226@jp.fujitsu.com>
References: <20090709165820.23B7.A69D9226@jp.fujitsu.com>
	 <20090709171122.23C3.A69D9226@jp.fujitsu.com>
Date: Thu, 9 Jul 2009 19:20:47 +0900
Message-ID: <28c262360907090320r51acdbedwee36e7af54bbd9f1@mail.gmail.com>
Subject: Re: [PATCH 3/5][resend] Show kernel stack usage to /proc/meminfo and 
	OOM log
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 5:12 PM, KOSAKI
Motohiro<kosaki.motohiro@jp.fujitsu.com> wrote:
> Subject: [PATCH] Show kernel stack usage to /proc/meminfo and OOM log
>
> The amount of memory allocated to kernel stacks can become significant and
> cause OOM conditions. However, we do not display the amount of memory
> consumed by stacks.'
>
> Add code to display the amount of memory used for stacks in /proc/meminfo.
>
>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: <cl@linux-foundation.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

-- 
Kind regards,
Minchan Kim
