Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbYENEWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbYENEWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 00:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYENEWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 00:22:39 -0400
Received: from ti-out-0910.google.com ([209.85.142.185]:21442 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYENEWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 00:22:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=c01dC3j0sxlCZTsCureFyplLC9gWLv2smUjR3q/tuPuKhKqrEK6C9GkwDW6YtgdLYfUEzm/NxkkUsslD6KW13EMX5Ut9Auc4GdkxqOTY6VXqFd44onEbkSY1PCpweohPmNDEgoaxAiZ5Qwb8ARlQMSMRTaQcBia1LJTH6DsuC3Y=
Message-ID: <386072610805132122l5d017fe1u404c38ea3f05664a@mail.gmail.com>
Date: Wed, 14 May 2008 12:22:35 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH 1/4] [mm] buddy page allocator: add tunable big order allocation
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org
In-Reply-To: <8A42379416420646B9BFAC9682273B6D015F52E4@limkexm3.ad.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
	 <1210588325-11027-2-git-send-email-cooloney@kernel.org>
	 <20080513110902.80a87ac9.kamezawa.hiroyu@jp.fujitsu.com>
	 <8A42379416420646B9BFAC9682273B6D015F52E4@limkexm3.ad.analog.com>
X-Google-Sender-Auth: e85f3f8cb57c4cd2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 7:42 PM, Hennerich, Michael
<Michael.Hennerich@analog.com> wrote:
>
>
>  >-----Original Message-----
>  >From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]
>  >Sent: Dienstag, 13. Mai 2008 04:09
>  >To: Bryan Wu
>  >Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
>  dwmw2@infradead.org;
>  >Michael Hennerich
>  >Subject: Re: [PATCH 1/4] [mm] buddy page allocator: add tunable big
>  order
>  >allocation
>  >
>  >On Mon, 12 May 2008 18:32:02 +0800
>  >Bryan Wu <cooloney@kernel.org> wrote:
>  >
>  >> From: Michael Hennerich <michael.hennerich@analog.com>
>  >>
>  >> Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
>  >> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>  >
>  >Does this really solve your problem ? possible hang-up is better than
>  >page allocation failure ?
>
>  On nommu this helped quite a bit, when we run out of memory, eaten up by
>  the page cache. But yes - with this option it's likely that we sit there
>  and wait form memory that might never get available.
>
>  We now use a better workaround for freeing up "available" memory
>  currently used as page cache.
>
>  I think we should drop this patch.
>

OK, I dropped it. And do you think the limited page_cache patch is the
replacement of this patch?

-Bryan
