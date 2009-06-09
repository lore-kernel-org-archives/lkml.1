Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZFIAnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZFIAnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 20:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbZFIAnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 20:43:32 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:55247 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbZFIAnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 20:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rSEaRoNbw/VDZzfO5IWvmbeKpTNuSoNAkFklGuMxXJh4aqytRY2UjSPU2a+efdUhW3
         2bvgFXdCg7xVBmQGRclvdp2RlQbC01iqPhVsTQFwx2jEyQzXBEuKs535VfenBNqZwyy4
         Q0IZ7suADDrqTt2Iek8cqloS+ICrlEeiMV44k=
MIME-Version: 1.0
In-Reply-To: <4A2CC52B.9010602@oracle.com>
References: <20090605075614.GC8171@cr0.nay.redhat.com>
	 <20090605095155.GC8354@cr0.nay.redhat.com>
	 <4A292B0D.8030807@oracle.com> <4A295AFB.80909@kernel.org>
	 <4A2A7F33.4030807@oracle.com> <4A2AEBE3.4000100@kernel.org>
	 <20090608015242.GB2596@cr0.nay.redhat.com>
	 <4A2CA96D.3090502@oracle.com>
	 <2375c9f90906072341o2cded749m45bdddfdb499469@mail.gmail.com>
	 <4A2CC52B.9010602@oracle.com>
Date: Tue, 9 Jun 2009 08:43:34 +0800
Message-ID: <2375c9f90906081743p77934f47n8ba1a018d333b95b@mail.gmail.com>
Subject: Re: /proc/kcore has a unreasonable size(281474974617600) in x86_64 
	2.6.30-rc8.
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 8, 2009 at 4:00 PM, Tao Ma<tao.ma@oracle.com> wrote:
>>>
>>> But the result is the same
>>
>> Yes?
>> Your printk() shows kcore size is: 5301604352, and in your subject it is
>> 281474974617600...
>>
>> Or they happened in the same time?
>
> yes. the same box and the same linux version.
> A bit strange.
>
> [taoma@ocfs2-test2 ~]$ dmesg|grep "high memory"
> high memory ffff88013c000000, size 5301604352
> [taoma@ocfs2-test2 ~]$ ll /proc/kcore
> -r-------- 1 root root 281474974617600 Jun  8 15:20 /proc/kcore

Really weird...
They should be the same. This means we have some problem in our procfs.

And, we have no problem on i386, I, myself, even can't reproduce this on my
x86_64 box...

Drop Cc to x86 people, add some Cc to proc people. :)

Eric, Alexey, any ideas?

Tao, would you like to send us your .config? Thanks.
