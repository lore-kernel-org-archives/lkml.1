Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbYJaPKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbYJaPKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 11:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYJaPK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 11:10:27 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:50993 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbYJaPK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 11:10:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eib4QSReMeHHBt47e22LyVxwIF9K7nPEr/7tQmySf3tF8F+cWZCC5vIIYDlssMJhdt
         gt0D+dLc2Gv+dXWx9teLwQNOOpUIKofcyUzXKoMn/h5r9M/bzR4ddVEk2oXtFwe7n0f9
         F4n009OY0BcDoSANYh2uZQNAXfeVXS5PA7YFQ=
Message-ID: <3aaafc130810310810q69eb83d7u83710008fa5a9e95@mail.gmail.com>
Date: Fri, 31 Oct 2008 11:10:25 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: staging: me4000 and relation to other data acquisition devices
Cc: "Greg KH" <gregkh@suse.de>, "Moritz Muehlenhoff" <jmm@debian.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081031150037.GA9314@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081028154918.GA5630@mediacenter>
	 <20081028103337.a021e85d.rdunlap@xenotime.net>
	 <20081028181402.GB4873@suse.de> <slrngghcgf.3do.jmm@inutil.org>
	 <3aaafc130810291737i41716bd2r767150b47239b0a1@mail.gmail.com>
	 <20081030014246.GA24081@kroah.com>
	 <3aaafc130810300725l1911cd7ay1ba8d33e96c8424b@mail.gmail.com>
	 <20081030152339.GA27095@suse.de>
	 <3aaafc130810300842h5a764903i61bfa5817c0fb493@mail.gmail.com>
	 <20081031150037.GA9314@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 11:00 AM, Greg KH <greg@kroah.com> wrote:
> On Thu, Oct 30, 2008 at 11:42:36AM -0400, J.R. Mauro wrote:
>> On Thu, Oct 30, 2008 at 11:23 AM, Greg KH <gregkh@suse.de> wrote:
>> > On Thu, Oct 30, 2008 at 10:25:30AM -0400, J.R. Mauro wrote:
>> >> Ok. I emailed a few of them. The ones I omitted either didn't have a
>> >> clear homepage/maintainer, had already sent a patch to the kernel, or
>> >> explicitly stated no intentions of going into mainline.
>> >
>> > Which ones were in the last 2 categories?
>>
>> The Alix driver seemed to be sent in already: http://lkml.org/lkml/2008/8/19/279
>>
>> The ov51x-jpeg driver's homepage mentions that there is a driver
>> already, but it doesn't do jpeg compression, since that kind of
>> shouldn't be done in the kernel. The out-of-tree driver does do the
>> compression in the kernel, but the author doesn't think it should go
>> into mainline. Or something like that.
>>
>> >
>> >> Maybe you could send me the Spreadsheet O' Drivers if you need more help?
>> >
>> > Yeah, I think I'll move this to a google docs file or somehow merge it
>> > with the information on the linuxdriverproject.org wiki.  Give me a few
>> > days.
>>
>> A google spreadsheet would be great for me. Maybe you could do both?
>>
>> >
>> >> I've also been wondering: should we contact the maintainers of the big
>> >> distros and make them aware of staging and have them work with us to
>> >> get whatever out-of-tree stuff they have more centralized? I don't
>> >> know if it's a good idea, but it could be. And if it is, I have no
>> >> idea where to start.
>> >
>> > I've already looked at what the following distros include in their
>> > kernel package:
>> >        - Fedora
>> >        - openSUSE
>> >        - Ubuntu
>> > so I have them on my list, and is where I took a number of the existing
>> > staging drivers from.
>> >
>> > If you could poke around other distro's kernels (like Mandrake and any
>> > other you can think of) and find out what they include, that would e
>> > great.
>>
>> Ok. I'll talk to distros not mentioned above and hopefully add
>> anything I find to the forthcoming spreadsheet.
>
> I've gone through the suse, fedora, ubuntu, and gentoo kernels and added
> everything that I have found (gentoo had a _lot_ of external kernel
> modules in their packaging system) to the wiki at:
>        http://www.linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
>
> I also dumped all of my spreadsheet information into here as well, as it
> didn't make sense to try to categorize it that way.
>
> So, feel free to clean up, and organize that wiki page with whatever
> else you have found.  Some of it still is not organized (like the huge
> list at the end of the page) and there might be duplicates as well.
>
> Thanks a lot for helping out.
>
> greg k-h
>

Thanks Greg. I tried to work on this page last night but when I
previewed my changes somehow the whole page was busted. I'll try to
add whatever I've found and GC/categorize the mess at the bottom.
