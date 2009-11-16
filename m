Return-Path: <linux-kernel-owner+w=401wt.eu-S1752598AbZKPSiC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbZKPSiC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:38:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZKPSiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:38:01 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:40561 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbZKPSiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:38:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OpnB4smijNj2lgcJZhDnyGoxlSyAFwWWPbiNDUyqyeb8QaefcZa/XHGDNnvabO2G7K
         yko6K7p5FxWxLVvWBYSD9nf1id+GUQMLkprUpTVnWBa0O145by5N9XAzMybs7Hm9BnMw
         9Ol2/DIVpCsiy1ako3Vd4wIF/bsmyswKJg6HE=
MIME-Version: 1.0
In-Reply-To: <x49iqdaz9kr.fsf@segfault.boston.devel.redhat.com>
References: <20091026172012.GC7233@duck.suse.cz>
	 <x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
	 <20091111141031.GA21511@duck.suse.cz>
	 <x493a4lot31.fsf@segfault.boston.devel.redhat.com>
	 <20091112172941.GK14528@duck.suse.cz>
	 <x49pr7npj71.fsf@segfault.boston.devel.redhat.com>
	 <20091116104744.GC23231@duck.suse.cz>
	 <20091116165804.GA19230@duck.suse.cz>
	 <x49iqdaz9kr.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 16 Nov 2009 19:38:06 +0100
Message-ID: <4e5e476b0911161038w61b4bc6ay59c381f0543e9575@mail.gmail.com>
Subject: Re: Performance regression in IO scheduler still there
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, jens.axboe@oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, mszeredi@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 6:03 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Jan Kara <jack@suse.cz> writes:
>
>> On Mon 16-11-09 11:47:44, Jan Kara wrote:
>>   OK, here are the numbers (3 runs of each test):
>> 2.6.29:
>> Threads       Avg             Stddev
>> 1     42.043333       0.860439
>> 2     40.836667       0.322938
>> 4     41.810000       0.114310
>> 8     40.190000       0.419603
>> 16    39.950000       0.403072
>> 32    39.373333       0.766913
>>
>> 2.6.32-rc7:
>> Threads       Avg             Stddev
>> 1     41.580000       0.403072
>> 2     39.163333       0.374641
>> 4     39.483333       0.400111
>> 8     38.560000       0.106145
>> 16    37.966667       0.098770
>> 32    36.476667       0.032998
>>
>>   So apparently the difference between 2.6.29 and 2.6.32-rc7 increases as
>> the number of threads rises. With how many threads have you been running
>> when using SATA drive and what machine is it?
>>   I'm now running a test with larger file size (8GB instead of 4) to see
>> what difference it makes.
>
> I've been running with both 8 and 16 threads.  The machine has 4 CPUs
> and 4GB of RAM.  I've been testing with an 8GB file size.

Other details may be relevant, e.g.the file system on which the file
is located, whether the caches are dropped before starting each run,
and so on.

Corrado

>
> Cheers,
> Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
