Return-Path: <linux-kernel-owner+w=401wt.eu-S1761209AbZEFW0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761209AbZEFW0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbZEFW0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:26:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46885 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755518AbZEFW0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:26:41 -0400
Date: Wed, 6 May 2009 18:24:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "IKEDA, Munehiro" <m-ikeda@ds.jp.nec.com>
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       jens.axboe@oracle.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       righi.andrea@gmail.com, agk@redhat.com, dm-devel@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org
Subject: Re: [PATCH 18/18] io-controller: Debug hierarchical IO scheduling
Message-ID: <20090506222458.GM8180@redhat.com>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <1241553525-28095-19-git-send-email-vgoyal@redhat.com> <4A0203DB.1090809@ds.jp.nec.com> <20090506215833.GK8180@redhat.com> <4A020CD5.2000308@ds.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A020CD5.2000308@ds.jp.nec.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 06:19:01PM -0400, IKEDA, Munehiro wrote:
> Hi,
>
> Vivek Goyal wrote:
>> Hi Ikeda,
>>
>> I think there is some issue with applying the patch. I think you have
>> forgotten to apply following patch and that's why seeing all the issues.
>>
>> "io-controller: Export disk time used and nr sectors dipatched through
>> cgroups"
>>
>> This patch changes elv_ioq_served() at the same time introduced additional
>> field of total_sector_service etc.
>>
>> Thanks
>> Vivek
>
> Oh!  you are right.  I missed it because it is out of the
> thread...

That's strange. In "mutt" I see this patch (patch number 7) as part of the
thread. Which mail client are you using. Not sure if it is mail client
specific thing or some issue with my way of using "git-send-email".

Thanks
Vivek
