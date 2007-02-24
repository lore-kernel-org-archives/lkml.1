Return-Path: <linux-kernel-owner+w=401wt.eu-S933359AbXBXDZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359AbXBXDZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 22:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933360AbXBXDZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 22:25:44 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:51010 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933359AbXBXDZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 22:25:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CowX6uI64F4st4bUmqhXDF3f333D822TmORVXz4qTdf8im0BA2oF4Li75xs9upEbuD7aHXS4BgZUPcwm0w3pXV2kGHDmGI/m6kHytcFZ2acpZ4LZzNXEOqEf3foKLOuJHJZkibw5kygy6xJbWU7ZbI1jTj/okj97wHiLeIYBkMk=
Message-ID: <f2b55d220702231925x2020d2a0lf4722c58ff55c72c@mail.gmail.com>
Date: Fri, 23 Feb 2007 19:25:37 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>, "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <f2b55d220702231651u2c1915b1we04de7ae41393874@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
	 <20070222125931.GB25788@elte.hu>
	 <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
	 <20070223003018.0d244576@lxorguk.ukuu.org.uk>
	 <f2b55d220702221847p6b28f6eehed1bb5b1b0edf9f4@mail.gmail.com>
	 <20070223123718.54c9670e@lxorguk.ukuu.org.uk>
	 <f2b55d220702231549g47a648e3xd4c9d4a730f0c4ea@mail.gmail.com>
	 <20070224010824.5cf6c0ac@lxorguk.ukuu.org.uk>
	 <f2b55d220702231651u2c1915b1we04de7ae41393874@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Michael K. Edwards <medwards.linux@gmail.com> wrote:
> which costs you a D-cache stall.)  Now put an sprintf with a %d in it
> between a couple of the syscalls, and _your_ arch is hurting.  ...

er, that would be a %f.  :-)

Cheers,
- Michael
