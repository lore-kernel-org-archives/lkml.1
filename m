Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbZCISVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbZCISVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZCISVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:21:07 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:53379 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbZCISVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:21:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=G8VDuVzxP95dWKUBC41XoFFdmXwLVodofWWL019TgIudAEDd5c4hE+x3gLGftK2qgd
         GvBTjvsJgSTHUbJYK+PLa0tI6Yh9P4kODMVhIiWYMsYwAxLP7hgFYTqvVmoo8tpMI5EH
         X1FsZdfvDU11wmKSLjmGovfAzTHuDwK9kCERI=
MIME-Version: 1.0
In-Reply-To: <20090309180143.GG32589@ldl.fc.hp.com>
References: <20090309063654.GB23137@ldl.fc.hp.com>
	 <20090309150453.GB7627@kroah.com>
	 <20090309165010.GB32589@ldl.fc.hp.com>
	 <20090309165807.GU25995@parisc-linux.org>
	 <20090309180143.GG32589@ldl.fc.hp.com>
Date: Mon, 9 Mar 2009 19:21:00 +0100
Message-ID: <19f34abd0903091121g73d6cdeeqfa8353b55a3e9607@mail.gmail.com>
Subject: Re: kobj refcounting weirdness
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Alex Chiang <achiang@hp.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>, kay.sievers@vrfy.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/9 Alex Chiang <achiang@hp.com>:
> * Matthew Wilcox <matthew@wil.cx>:
>> On Mon, Mar 09, 2009 at 10:50:10AM -0600, Alex Chiang wrote:
>> > I thought about the allocators returning a pointer to the same
>> > location that maybe has some valid looking data hanging around,
>> > but it's not wise for someone like me to go pointing fingers at
>> > the allocator before I've proven the bug isn't in my code. ;)
>>
>> Slab poisoning would be the logical next thing to try to decide whether
>> the allocator is wrong or you're using it wrong ;-)
>
> We had a double free in the PCIe port driver. Removing the double
> free seems to fix my issue.
>
> The double free is only in Jesse's linux-next branch, so no need
> to worry about it in mainline/stable.

Hi,

Sorry for butting in, just wondering if I could have the patch to fix
the double free? :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
