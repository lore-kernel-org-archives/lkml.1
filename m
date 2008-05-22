Return-Path: <linux-kernel-owner+w=401wt.eu-S1754735AbYEVPrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735AbYEVPrs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYEVPrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:47:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:5488 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYEVPrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qQ/6rRArB602JzqGzgm2pJwZEfCWEnIKT59hhtCQ5bPfgA6WeHxJzLM73iVJSXP6/+QAu9W/3JxPPD2hNbnvfQFaxletwHM/p1ejMzl/bjbKMhxx2bk+NS0r9Oa28dzEj+TD1NW5Dsh4o8iFD3g5XSWFlj8Xzt9BEUVrFoCK3sM=
Message-ID: <32209efe0805220847h5495fd7ctf1c3b9fdd387ec2d@mail.gmail.com>
Date: Thu, 22 May 2008 08:47:36 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: Number of bugs - statistics
Cc: "Adrian Bunk" <bunk@kernel.org>,
       "Bosko Radivojevic" <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080522075135.4933161c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com>
	 <20080522144114.GC27301@cs181133002.pp.htv.fi>
	 <20080522075135.4933161c@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 7:51 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Thu, 22 May 2008 17:41:14 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
>
>> On Thu, May 22, 2008 at 02:28:17PM +0200, Bosko Radivojevic wrote:
>>
>> > Hi!
>>
>> Hi Bosko!
>>
>> > Is there any kind of analysis of number of (reported or resolved)
>> > bugs through time in Linux kernel floating around? I'm trying to
>> > convince my colleagues that newer kernel version does not mean more
>> > bugs than the previous 'well tested' ones.
>>
>> We definitely have many regressions (something that previously worked
>> does no longer work) in each kernel.
>
> ... and many of those regressions are things people are unlikely to
> hit. And we fix many long standing bugs as well.
>
> Maybe some other data:
> * The incoming rate of ACPI bugs has been pretty much flat the last 3
> years, while the number of Linux (and ACPI) users has grown
> significantly. The number of unfixed bugs has more than halved, from
> over 200 to well below 100.
> * The SCSI maintainer also reports that he sees flat to declining bug
> rates; again with the increase in Linux user base that is a good sign
>
>
>>
>> > Any kind of (research) reports or papers that address this issue is
>> > more than welcome.
>>
>> Any such reports or papers would anyway be flawed since we have no
>> data one could use for doing serious statistics.
>
> We have data for 2.6.25 at least, on which we can and do serious
> statistics. Unfortunately we don't have that for older kernels.
> What we have for older kernels only comes from lkml reports (which
> isn't very representative), but that shows that the bug report pattern
> is a bit spikey, in that kernels that get picked up by popular
> distributions get more reports than those that don't (no big surprise,
> those just have a much larger user base), but otherwise there's no up
> or down trend to be seen there.
>

Majority of old bugs that are still open are of "hard to reproduce"
category. That means you are not very likely to hit them. Those can
be: legacy devices failing, relatively rare hardware, code clean-ups
etc. You can't find  really critical long standing bugs in the old
backlog. It doesn't mean old bugs don't get fixed, rather get less
priority that severe bugs and regressions.
 With emphasys that was put on cleaning up bugs by Andrew and other
developers, bugs are taken even more seriously than before. New bugs,
regressions are being tracked aggressively, so they don't stay open
for long time. You can search for Rafael's regression reports and
sample  time line of a reported regression: they are short lived bugs.
Overall, each kernel release has great deal of improvement over older
ones, by nature of Linux. Many distros now tend to stay as close with
new releases of main line as possible. This seems to be the best way
to get all the bug fixes, optimizations, and features.
Regards,
 --Natalie
>
>>
>> > Thanks!
>> >
>> > Sincerely,
>> > Bosko
>>
>> cu
>> Adrian
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
