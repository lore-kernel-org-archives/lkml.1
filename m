Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbXIYUvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbXIYUvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXIYUvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:51:11 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:34284 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740AbXIYUvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:51:10 -0400
Message-ID: <46F974B8.3040705@davidnewall.com>
Date: Wed, 26 Sep 2007 06:21:04 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
References: <56705.193.171.152.61.1190289559.squirrel@webmail.marek.priv.at> <46F29A9A.4070806@davidnewall.com> <200709201817.17282@x5> <46F2B59F.8090709@davidnewall.com> <46F2DDD0.3030500@tmr.com> <46F380E4.4040606@davidnewall.com> <20070924213215.GA32716@vino.hallyn.com> <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <Pine.LNX.4.64.0709251715390.945@fbirervta.pbzchgretzou.qr> <46F92C17.3060405@davidnewall.com> <Pine.LNX.4.64.0709251748240.945@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0709251748240.945@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Sep 26 2007 01:11, David Newall wrote:
>   
>> Jan Engelhardt wrote:
>>     
>>> On Sep 26 2007 00:40, David Newall wrote:
>>>   
>>>       
>>>> Miloslav Semler pointed out that a root process can chdir("..") out of its
>>>> chroot.
>>>>         
>>> So what? Just do this: chdir into the root after chroot.
>>>       
>> I don't think so.  His exploit just got me all the way out of a chroot within a
>> chroot within a chroot, inclusive of lots of chdirs.
>>     
>
> Close all fds that point to directories outside the root ;-)
>   

Nope, still gets out.
