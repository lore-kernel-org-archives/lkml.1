Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0CDP1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 10:27:49 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:64952 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab0CDP1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 10:27:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=k0mnN40GTgbXg4zeQj78g0TJxWZdsG5I8QJ9f7MerVY0dkt1VaAZCI1sz0GocgXfKs
         G+97IGVqsE/e/ZOa7Z9NCO4XD+iGoGd/nt0GWpUKhAafzFye7i3yNWm/Sbp/2KRkLqHt
         bLD9u0w6eMu3J9o4r5a+LCrz0Lw86l10vTDqA=
Date: Thu, 4 Mar 2010 23:30:42 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: M G Berberich <berberic@fmi.uni-passau.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.33 dies on modprobe
Message-ID: <20100304153042.GA4614@hack>
References: <fa.S/rvLm1aQlDSqPwVJz5B+5vHjbM@ifi.uio.no> <fa.+Pg2gFpQSg5k/1mCpBdt8xMXeqY@ifi.uio.no> <fa.0/xGeZctWXDyX0DAp6opgP1HP7w@ifi.uio.no> <fa.kPSENj9DWu0Q8xolQMDkRvAwxQ0@ifi.uio.no> <fa.JUJQsT7bECqtd8JSoNY+SBdASCE@ifi.uio.no> <fa.Lya/54V1PJgwjc8uy1Yk4NyYUh4@ifi.uio.no> <20100303230438.GA3363@invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100303230438.GA3363@invalid>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 12:04:38AM +0100, M G Berberich wrote:
>Hello,
>
>Am Mittwoch, den 03. März schrieb Américo Wang:
>> On Wed, Mar 3, 2010 at 5:08 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> > On Wed, Mar 3, 2010 at 4:58 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> >> Ok, below is my patch, I am not sure it could fix the BUG for you,
>> >> but it could fix the WARNING. But perhaps they are related.
>> >>
>> >> Please give it a try.
>> >>
>> >
>> > Oops! Ignore the patch, it should not be correct, I will send a
>> > correct version soon.
>> > Sorry.
>> >
>> 
>> Here we go:
>
>Seems to fix the warning, but not the modprobe-Oops.
>

Thanks much for your testing!

Could you please try to turn on DEBUG_KOBJECT and boot your kernel
with "initcall_debug"? And then show us your dmesg.

Regards.
