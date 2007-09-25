Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbXIYRJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbXIYRJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759875AbXIYRJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:09:16 -0400
Received: from h90-m1.hosting90.cz ([81.0.225.70]:38803 "EHLO
	h90-m1.hosting90.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068AbXIYRJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:09:14 -0400
Message-ID: <46F940B9.8060006@prepere.com>
Date: Tue, 25 Sep 2007 19:09:13 +0200
From: Miloslav Semler <majkls@prepere.com>
User-Agent: IceDove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: serge@hallyn.com, davidsen@tmr.com, philipp@marek.priv.at, 7eggert@gmx.de,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5> <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com> <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com> <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <Pine.LNX.4.64.0709251715390.945@fbirervta.pbzchgretzou.qr> <46F92C17.3060405@davidnewall.com> <Pine.LNX.4.64.0709251748240.945@fbirervta.pbzchgretzou.qr> <46F9351D.8020906@prepere.com> <Pine.LNX.4.64.0709251847570.945@fbirervta.pbzchgretzou.qr> <46F93EAF.20706@prepere.com> <Pine.LNX.4.64.0709251903480.945@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709251903480.945@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt napsal(a):
> On Sep 25 2007 19:00, Miloslav Semler wrote:
>   
>>>> This  does not help.  Let's try:
>>>> chroot somewhere
>>>> mkdir foo
>>>> fd = open /
>>>> chroot foo
>>>>     
>>>>         
>>> ('fd' implicitly closed and chdir to /foo)
>>>   
>>>       
>> Really? Try it. I am sure, that this works. You can create directory in chroot
>> and break chroot by this. fd is not closed, because linux doesn't close
>> descriptors by chroot syscall. this can be done every time if you have
>> CAP_SYS_CHROOT.
>>     
>
> In case you have not followed my earlier email, I'll repost:
>
> |>> So what? Just do this: chdir into the root after chroot.
> |>
> |> I don't think so.  His exploit just got me all the way out of a 
> |> chroot within a chroot within a chroot, inclusive of lots of 
> |> chdirs.
> |>
> |
> |Close all fds that point to directories outside the root ;-)
>
> Perhaps that was formulated a bit sloppy. It of course means
> "On chroot(2), implicitly close all FDs that point outside."
>   
yes, but I can use fds from chroot ;-) ....
