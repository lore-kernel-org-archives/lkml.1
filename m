Return-Path: <linux-kernel-owner+w=401wt.eu-S1756941AbYKDWmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941AbYKDWmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbYKDWmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:42:33 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:1387 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbYKDWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:42:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VhvoOPrPBx4lkCJbDv70FJB+SYoyaVCWG77XXrV+EV6H8r8ZDQxxiE3owC65WTap7X
         wrUYpSL2ehSufkM3DTphgxSQYGgfkjNxKts5QOwSQobx63rPVfURNW+XIxsRy3WebLPY
         d2g6bgytHY+21XNkfSuFhD9IQXnI8fuCv8y8E=
Message-ID: <19f34abd0811041442o22eaf009k4fa9a33af8cb2d5d@mail.gmail.com>
Date: Tue, 4 Nov 2008 23:42:31 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] drm: fix leak of uninitialized data to userspace
Cc: "Ingo Molnar" <mingo@elte.hu>, "Vegard Nossum" <vegardno@ifi.uio.no>,
       "Dave Airlie" <airlied@redhat.com>,
       "Sitsofe Wheeler" <sitsofe@yahoo.com>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
In-Reply-To: <20081104222326.GA16460@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010100200.GA752@thuin.ifi.uio.no>
	 <20081010101753.GE15139@elte.hu> <20081104213859.GA3516@kroah.com>
	 <20081104221730.GA27635@elte.hu> <20081104222326.GA16460@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 4, 2008 at 11:23 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Nov 04, 2008 at 11:17:30PM +0100, Ingo Molnar wrote:
>>
>> * Greg KH <greg@kroah.com> wrote:
>> > What ever happened to this patch?  Did it go into Linus's tree?  If
>> > so, I can't seem to find it :(
>>
>> i'm not doing DRM patches - tip/out-of-tree is for pure out-of-tree
>> hotfixes.
>
> So it goes no where?
>
> Dave, any plan to pick this up and get it to Linus?

For Dave: You may also remove the "completely untested" line of the
original submission and add Sitsofe's Tested-by line:

http://lkml.org/lkml/2008/10/11/108

Original patch can be found here:

http://lkml.org/lkml/2008/10/10/115

:-)

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
