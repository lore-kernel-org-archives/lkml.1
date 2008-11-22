Return-Path: <linux-kernel-owner+w=401wt.eu-S1757856AbYKVWtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757856AbYKVWtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 17:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbYKVWst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 17:48:49 -0500
Received: from po-out-1718.google.com ([72.14.252.158]:53816 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbYKVWsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 17:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ew8h1rUmmaFUs9buSJLuH1YlIKZ00xs9Q9yfmWvXIhQ38kRkA1fWyicG+5tPjsmwLi
         YXhmBMU3rHusGXgUIKo7e1oib3k5xnwASrt7TEbJJw5B2o/vMNEBbQd7kFgk2q3S63IO
         PmIEjfaQgVhR5dDA5JKE5vAfSh/sAZMG8w7KU=
Message-ID: <19f34abd0811221448p34770633keb5ea97f8e9bf62d@mail.gmail.com>
Date: Sat, 22 Nov 2008 23:48:46 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC][PATCH] sysrq-j: emergency shell
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20081122190719.3ef24df6@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081121235159.GA15861@localhost.localdomain>
	 <20081122172702.GB2748@x200.localdomain>
	 <20081122190719.3ef24df6@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2008 at 8:07 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > It seems that keyboard input will go to the shell only half of the
>> > time; the other half goes to whatever program was running there in
>> > the first place. I tried to kill the other users of the TTY using
>> > TIOCSCTTY, but it seems not to have worked. Any ideas?
>>
>> This should go in together with CVE number attached.
>
> TIOCSTTY isn't supposed to kill anything.

Oops, by killing, I meant simply to take it exclusively:

              EPERM, unless the caller is root and arg equals 1, in which case
              the  tty is stolen, and all processes that had it as controlling
              tty lose it.

But I realize that this does not necessarily mean that the other
processes cannot read from or write to the tty anymore. Do you know
how to do that? :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
