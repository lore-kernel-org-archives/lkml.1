Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYHVM7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYHVM7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYHVM7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:59:45 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:24053 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbYHVM7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T6wxSFeb4asMwbxC5FfQh5Dj35avn2/ZGfHApbUPdkWrmABItcpbfgCTGGifuZUOiX
         kFzOp4gKMs1bZXx+YKuKYKu8Om7u2vKsByz7EqdXTmd0szKHbFdPIxgCi3KbpRTREW2G
         FbzYm+D99Gm+Ulkqt9i2QLwODv9xl4BWSzfeM=
Message-ID: <81b0412b0808220559w502edf03y7f318d0f3673884@mail.gmail.com>
Date: Fri, 22 Aug 2008 14:59:43 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Wappler Marcel" <Marcel.Wappler@bridgeco.net>
Subject: Re: Behaviour of the VM on a embedded linux
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <83116F0A4FF67A4F97BA0B6E408C48E30289D8F0@zuerich.BC-Int.NET>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83116F0A4FF67A4F97BA0B6E408C48E30289D8F0@zuerich.BC-Int.NET>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/22 Wappler Marcel <Marcel.Wappler@bridgeco.net>:
> I'm trying to figure out whats going on an embedded system I have to
> deal with. It's running a 2.6.24.7 kernel on 32 MBytes of RAM.
> There is no swapping. There are some daemons and shells running and
> - a big monolithic c++ application.
>
> The application runs a lot of pthreads on different real time priority levels.
> It looks like the application consumes  a huge
> ammount of real memory in contrast to the assumption, that large code
> size is no problem due to paging out pages with unused code.

Maybe the kernel wont page anything if the paging support is compiled out.
IOW, you still need paging code even if there is now swap partitions.
