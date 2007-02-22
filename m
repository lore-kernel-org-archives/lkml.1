Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbXBVVmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbXBVVmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbXBVVmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:42:10 -0500
Received: from an-out-0708.google.com ([209.85.132.244]:14034 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbXBVVmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:42:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oCp9D6ityxeNr3SYjLFzo0r352d8ltmKA9JCkewpgORPG3jmxrkjW4N5DSQ/g5N/pw83z0GwskMAWma9LCQQMQcxQAZ9ZX2mNHBr0Gv80vQkxKUwev4k03TNSnVxqyesnVunWmbulymLpJTgcv1SO7Y+gzDJLZ8n1HrVv9dK+Nk=
Message-ID: <f2b55d220702221342n5d712f16hfe689ee837b3516d@mail.gmail.com>
Date: Thu, 22 Feb 2007 13:42:04 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "David Miller" <davem@davemloft.net>, johnpol@2ka.mipt.ru,
       arjan@infradead.org, drepper@redhat.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, hch@infradead.org, akpm@zip.com.au,
       alan@lxorguk.ukuu.org.uk, zach.brown@oracle.com, suparna@in.ibm.com,
       davidel@xmailserver.org, jens.axboe@oracle.com, tglx@linutronix.de
In-Reply-To: <20070222143145.GA3246@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070222113148.GA3781@2ka.mipt.ru>
	 <1172145159.3531.253.camel@laptopd505.fenrus.org>
	 <20070222123929.GA5208@2ka.mipt.ru>
	 <20070222.054127.104035694.davem@davemloft.net>
	 <20070222143145.GA3246@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/07, Ingo Molnar <mingo@elte.hu> wrote:
> Secondly, even assuming lots of pending requests/async-threads and a
> naive queueing model, an open request will eat up resources on the
> server no matter what.

Another fundamental misconception.  Kernel AIO is not for servers.
One programmer in a hundred is working on a server codebase, and one
in a thousand dares to touch server plumbing.  Kernel AIO is for
clients, especially when mated to GUIs with an event delivery
mechanism.  Ask yourself why the one and only thing that Windows NT
has ever gotten right about networking is I/O completion ports.

Cheers,
- Michael
