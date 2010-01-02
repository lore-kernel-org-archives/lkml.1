Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315Ab0ABB5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0ABB5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 20:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261Ab0ABB5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 20:57:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:45315 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab0ABB5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 20:57:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HBdyfZoJ9LNHcYB086dKcNCtLGhRF80HghFT3LvMmtHXIjXHLEe5Qynb15KZyjJh9m
         5h6uxn55Uq0cT6CF7WdsBFQfJzILjmkDDVG1a3Y3TSYaJDr7Lp8UHNXHO/XMg1JAzVGc
         59zSdBmjzCoZTaDuleEkhRt1Th/iG+ulv6NVc=
MIME-Version: 1.0
In-Reply-To: <200912302253.53285.rjw@sisk.pl>
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
	 <NJVdobuNFNK.A.1VG.EnhOLB@chimera> <20091230091818.GW4489@kernel.dk>
	 <200912302253.53285.rjw@sisk.pl>
Date: Fri, 1 Jan 2010 20:57:35 -0500
Message-ID: <ea6602021001011757y21c6b859ocdbea233070fb31c@mail.gmail.com>
Subject: Re: [Bug #14940] cfq-iosched: tiobench regression
From: Vikram Dhillon <dhillonv10@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Shaohua Li <shaohua.li@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 30, 2009 at 4:53 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday 30 December 2009, Jens Axboe wrote:
>> On Tue, Dec 29 2009, Rafael J. Wysocki wrote:
>> > This message has been generated automatically as a part of a report
>> > of recent regressions.
>> >
>> > The following bug entry is on the current list of known regressions
>> > from 2.6.32.  Please verify if it still should be listed and let me know
>> > (either way).
>> >
>> >
>> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=14940
>> > Subject             : cfq-iosched: tiobench regression
>> > Submitter   : Shaohua Li <shaohua.li@intel.com>
>> > Date                : 2009-12-24 0:55 (6 days old)
>> > References  : http://marc.info/?l=linux-kernel&m=126161612401994&w=4
>>
>> I don't think this should be labelled as a regression. It was already
>> known that we'd have less throughput for the many clients cases, it was
>> a trade off that was made to improve latencies.
>
> OK, I've closed it as "documented".
>
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Thanks for this update, I guess we I can make like a separate category
of documented regressions because this could be helpful to other
distributions as they update to the newer kernels :D

-- 
Regards,
Vikram Dhillon

~~~
There are lots of Linux users who don't care how the kernel works, but
only want to use it. That is a tribute to how good Linux is.
-- Linus Torvalds
