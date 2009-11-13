Return-Path: <linux-kernel-owner+w=401wt.eu-S1757272AbZKMTiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbZKMTiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932070AbZKMTh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:37:58 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:37606 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073AbZKMTh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:37:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qqxWPi6M4r1pl6YOc5YJpNOc1p2Hf2TjDu0h+7vN5HbyQeS/2EWU0bsLQRAdXdbRUu
         c869azObw5/Wbi/FaToCFzL0QgvbJBW6heL03UL++K+pT1SReI9BWBcMulvWXxCA3dSK
         wU0AY0hSjaF9+xDBXrUv/1VhMSeFVnGkBIAPo=
MIME-Version: 1.0
In-Reply-To: <20091113192648.GK17076@redhat.com>
References: <1258068756-10766-1-git-send-email-vgoyal@redhat.com>
	 <1258068756-10766-6-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911130246m372eb8e8x7b98f13278515a95@mail.gmail.com>
	 <20091113151815.GC17076@redhat.com>
	 <20091113161506.GF17076@redhat.com>
	 <4e5e476b0911131040l58dc1e04ncbb4be7ca2ca7227@mail.gmail.com>
	 <20091113192648.GK17076@redhat.com>
Date: Fri, 13 Nov 2009 20:38:03 +0100
Message-ID: <4e5e476b0911131138o5df55986qbc6e76889d9e68e1@mail.gmail.com>
Subject: Re: [PATCH 05/16] blkio: Implement per cfq group latency target and 
	busy queue avg
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, akpm@linux-foundation.org, riel@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 8:26 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Nov 13, 2009 at 07:40:51PM +0100, Corrado Zoccolo wrote:
>> Great.
>> I have only one concern, regarding variable naming:
>> group_target_lat is a bit misleading. The fact is that it will be
>> larger for higher weight groups, so people could ask why are you
>> giving more latency to higher weight group...
>> Actually, it is the group share of the scheduling round, so you should
>> name it accordingly.
>>
>
> How about "group_slice" ?
If you haven't something similar in other parts of the code, it will be fine

Corrado
>
> Thanks
> Vivek
>
>
