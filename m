Return-Path: <linux-kernel-owner+w=401wt.eu-S932116AbZLJAkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbZLJAkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbZLJAkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:40:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46406
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759097AbZLJAkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:40:24 -0500
Date: Wed, 09 Dec 2009 16:40:29 -0800 (PST)
Message-Id: <20091209.164029.112221779.davem@davemloft.net>
To: jkosina@suse.cz
Cc: rudy.matela@gmail.com, wharms@bfs.de, kas@fi.muni.cz, khc@pm.waw.pl,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Coding style correction on some drivers that use
 Generic HDLC
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.0912100025190.3755@pobox.suse.cz>
References: <4B1FC5A4.9030300@bfs.de>
	<235c15c10912091309q6c20b417y3f80dbac0be2a073@mail.gmail.com>
	<alpine.LNX.2.00.0912100025190.3755@pobox.suse.cz>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Thu, 10 Dec 2009 00:26:57 +0100 (CET)

> On Wed, 9 Dec 2009, Rudy Matela wrote:
> 
>> > It is ok until the driver is removed, if this "issue" is not fixed it 
>> > will trigger any check-coding-style and generate new patches. Since it 
>> > involves no code changes it is harmless.
>>   Sould I keep sending coding style corrections to the Linux Kernel?
>> I'm trying to help, but if i'm just being annoying, please tell me and
>> I can try to contribute in a better way.  :-)
> 
> Coding style corrections (if they really improve readability of the code), 
> comment fixes (if they really make grepping for things better or make the 
> whole text more understandable) are welcome and I will happily merge them.
> 
> What I usually don't merge are purely whitespace "fixes", which don't 
> really fix anything in fact.

I think the whitespace ones here are extremely valuable, the code is
amazingly annoying to read as it is.

It boils down to this:

	foo() is a C function call

	foo () is a C operation like 'if', 'while' etc.

and people's brains are wired to this association.
