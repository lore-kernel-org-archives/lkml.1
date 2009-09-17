Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbZIQDQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbZIQDQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbZIQDQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:16:47 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:64388 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600AbZIQDQr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:16:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OmPX8FRdSf0HHavDwBd3S1jPe2Q8X0Fj2+8UZJYYdx1CtkGxXA8WthRS9BJuFwa/MR
         DVhZon6E5ePHHduTxHmxjRRoHj717eD+JBIUDi8PbF1bKt/DGUTtQIYfM5Wj1AqZq90+
         7bcNvp/EkTvGku0M6YZOQDg4tvddCDYO2pXz0=
MIME-Version: 1.0
In-Reply-To: <1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
	 <1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
Date: Thu, 17 Sep 2009 11:09:17 +0800
Message-ID: <2375c9f90909162009w5cca547ah5df74972694eab09@mail.gmail.com>
Subject: Re: kcore patches (was Re: 2.6.32 -mm merge plans)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/16 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> Am�+1rico_Wang さんは書きました：
>> On Wed, Sep 16, 2009 at 7:15 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>>#kcore-fix-proc-kcores-statst_size.patch: is it right?
>>>kcore-fix-proc-kcores-statst_size.patch
>>
>> Hmm, I think KAMEZAWA Hiroyuki's patchset is a much better fix for this.
>> Hiroyuki?
>>
> Hmm ? My set is not agaisnt "file size" of /proc/kcore.
>
> One problem of this patch is..this makes size of /proc/kcore as 0 bytes.
> Then, objdump cannot read this. (it checks file size.)
> readelf can read this. (it ignores file size.)

Hmm, ok.


>
> I wonder what you mention is.... because we know precise kclist_xxx
> after my series, we can calculate kcore's size in precise by
> get_kcore_size().


Yeah, that is why I think your patchset for kcore can replace this.

>
> It seems /proc's inode->i_size is "static" and we cannot
> provides return value of get_kcore_size() directly. It may need
> some work and should depends on my kclist_xxx patch sets which are not
> in merge candidates. If you can wait, I'll do some work for fixing this
> problem. (but will not be able to merge directly against upstream.)
>
> But for now, we have to use some fixed value....and using above
> patch for 2.6.31 is not very bad.


Just saw your new patchset for this, I will review them.

Thanks.
