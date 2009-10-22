Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbZJVTh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbZJVTh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 15:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756716AbZJVTh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 15:37:27 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:58167 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756669AbZJVTh0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 15:37:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=GQCBH17OA5tsSlkRlym/AkWmv3BS1IBeseeKymZaqapzvbmMRPWbW5q1ZWmDAUMN3G
         mBTUQxiOuuhr1/q4UBwLQfoIY0Y4/T3VKxbrDmO4QWreJvsl+6HGgU1Rc2keAXKE8aYk
         CMc5SnXP+3yWoBS1GXeXZgRmAh24sdA06O+7Q=
MIME-Version: 1.0
In-Reply-To: <20091022191954.GB6611@elf.ucw.cz>
References: <20091006200339.GA1538@ucw.cz> <20091017163627.GB1423@ucw.cz> 
	<f17812d70910200859v6d18e81bs2760d8af1d8da5bf@mail.gmail.com> 
	<f17812d70910220705o9f4a0ddwa22157b59a519350@mail.gmail.com> 
	<20091022174816.GC5325@elf.ucw.cz> <f17812d70910221126k50c4ea7em9d58f6e85db884ae@mail.gmail.com> 
	<20091022191954.GB6611@elf.ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 23 Oct 2009 03:28:52 +0800
Message-ID: <f17812d70910221228y6613ff5eg813129b37ccfe0a1@mail.gmail.com>
Subject: Re: zaurus: cleanup sharpsl_pm.c
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 3:19 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Fri 2009-10-23 02:26:55, Eric Miao wrote:
>> > Introduce separate set of battery limits for corgi. This fixes
>> > compilation, and the values probably should be subtly different, too.
>>
>> [Why I'm receiving this for twice ....?]
>
> No idea. Perhaps once from maillist?
>
>> Pavel,
>>
>> Anyway, I was thinkin maybe we need a shared table before there
>> are real requirements for different machines to have their own?
>
> Well, I'd say that the sharing leads to some very ugly code. ... so
> I'd preer it unshared.
>

I suggest to re-name it to "sharpsl_" something instead of "spitz_",
to be less confusing at this moment.

> But if you would prefer, I can prepare patch without the table
> moving...?
>

That would be appreciated.

>                                                                Pavel
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
>
