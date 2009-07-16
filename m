Return-Path: <linux-kernel-owner+w=401wt.eu-S1751430AbZGPEBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbZGPEBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 00:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbZGPEBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 00:01:40 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:34867 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbZGPEBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 00:01:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xrG+haRLbx5FZgkDI05zsw5pUBnCjxdwH9VjeG/9D48fdeGA823a7QHyU4O906YPyA
         ZV57E4LdXmQEuE0ecrX5bJ7KmSvGOMM+1yhqVjpNFPQ34nwUMsTEIorV8YGbEu6QO0HB
         jarMxlUkqszajdMUjvb5UYRCbYwFVYaoYtnIo=
MIME-Version: 1.0
In-Reply-To: <20090715201654.550cb640.akpm@linux-foundation.org>
References: <20090716094619.9D07.A69D9226@jp.fujitsu.com>
	 <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
	 <20090715201654.550cb640.akpm@linux-foundation.org>
Date: Thu, 16 Jul 2009 13:01:37 +0900
Message-ID: <28c262360907152101y15d7edc6m3e3cf4d3473b0008@mail.gmail.com>
Subject: Re: [PATCH 1/3] Rename pgmoved variable in shrink_active_list()
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 12:16 PM, Andrew
Morton<akpm@linux-foundation.org> wrote:
> On Thu, 16 Jul 2009 09:52:34 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>>       if (file)
>> -             __mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
>> +             __mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
>>       else
>> -             __mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
>> +             __mod_zone_page_state(zone, NR_ACTIVE_ANON, -nr_taken);
>
> we could have used __sub_zone_page_state() there.

Yes. It can be changed all at once by separate patches. :)



-- 
Kind regards,
Minchan Kim
