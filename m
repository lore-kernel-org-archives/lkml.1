Return-Path: <linux-kernel-owner+w=401wt.eu-S1765286AbYEVHLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765286AbYEVHLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 03:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758061AbYEVHLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 03:11:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:56464 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbYEVHLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 03:11:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iVnY7fIfJweHplH2smofT8wg4PShAty3kZCrffInZis/7LodffrtSIaRfMp+OFEePTRvlo1lyJ+tWo7CPFD6i/NbRz+2Q0S/tgbgBu/w5tKEccGvKcJ4oRPoeDOZ1xl2RtUZgkEinYuQ2dZGwKHVFU0vePw+CVH/d1a+dO2DX/c=
Message-ID: <4e1d1a240805220011r6f0b4565l338293c66aec96b8@mail.gmail.com>
Date: Thu, 22 May 2008 09:11:43 +0200
From: "=?ISO-2022-JP?B?GyRCJDkkayQvJGEbKEI=?=" <surkum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: fork: Resource temporarily unavailable / cant start new threads
In-Reply-To: <82fa9e310805211709i3993cac2n58152cf11a3ef8a4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82fa9e310805201126q45e869bdub74a947068fe612a@mail.gmail.com>
	 <20080521132845.72db5748.randy.dunlap@oracle.com>
	 <82fa9e310805211339o3090e0d0le8503051d3e0aa38@mail.gmail.com>
	 <48348AFA.1070900@oracle.com>
	 <82fa9e310805211408o65b49923jd9bf4a6c89b97c30@mail.gmail.com>
	 <20080521143248.baee1391.randy.dunlap@oracle.com>
	 <82fa9e310805211551oea0dfd9mdb7dfaed2b2d98fc@mail.gmail.com>
	 <20080521163503.000afd61.randy.dunlap@oracle.com>
	 <82fa9e310805211709i3993cac2n58152cf11a3ef8a4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take a look at this guide to install the kernel source on fedora 9

http://www.mjmwired.net/resources/mjm-fedora-f9.html#kernelsrc

2008/5/22 mark <markkicks@gmail.com>:
> On Wed, May 21, 2008 at 4:35 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>> > I can send you some debug patches that will print out the specific
>>> > problem area.  Do you want to do that?  Can you rebuild and install
>>> > a new kernel?
>>> Is it possible to get this debug messages by turning on some flags?
>>> If not yes, pl. send debug patches. its a live box and  I will try to do it!
>>>
>>> This is my system / kernel info:
>>> uname -a
>>> Linux XXX 2.6.25.3-18.fc9.x86_64 #1 SMP Tue May 13 04:54:47 EDT 2008
>>> x86_64 x86_64 x86_64 GNU/Linux
>>
>> I made a small patch to a vanilla kernel.org 2.6.25.3 kernel tree.
>> Hopefully it applies cleanly to that fc9 kernel source, but check/verify
>> that first before going any further.
>
> Thanks a lot for the patch,
> This is kind of weird..  but there is no file  kernel/fork.c
>
> [mark@localhost 2.6.25.3-18.fc9.i686]$ find . -iname '*fork*' -print
> [mark@localhost 2.6.25.3-18.fc9.i686]$ rpm -ql
> [mark@localhost 2.6.25.3-18.fc9.i686]$ rpm -ql kernel-devel | grep fork
> [mark@localhost 2.6.25.3-18.fc9.i686]$ pwd
> /usr/src/kernels/2.6.25.3-18.fc9.i686
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
するくめ
