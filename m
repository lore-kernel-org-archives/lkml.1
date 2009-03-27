Return-Path: <linux-kernel-owner+w=401wt.eu-S1757909AbZC0XBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbZC0XBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761798AbZC0XBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:01:30 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:54773 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762070AbZC0XB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:01:29 -0400
Message-ID: <49CD5AC6.3020806@msgid.tls.msk.ru>
Date: Sat, 28 Mar 2009 02:01:26 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: nicolas sitbon <nicolas.sitbon@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: epoll_ctl and const correctness
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>	 <49CAA055.5060603@goop.org>	 <84a01a8b0903251437l9f9059s3c548b5d35ea47d4@mail.gmail.com>	 <84a01a8b0903270244s146ca50cr2758d36c2d9d77cd@mail.gmail.com>	 <49CD4967.2090606@msgid.tls.msk.ru>	 <84a01a8b0903271517t668c6276l7fe098d74c24b836@mail.gmail.com>	 <84a01a8b0903271530of8d43ffhf77e7ba73e309f75@mail.gmail.com>	 <49CD564E.6050101@msgid.tls.msk.ru> <84a01a8b0903271555i7a4fea50nd95009539aa2f94d@mail.gmail.com>
In-Reply-To: <84a01a8b0903271555i7a4fea50nd95009539aa2f94d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nicolas sitbon wrote:
> Do you read my post? there is a confusion, my question was first : why
> the structure isn't const? and you answer me. ok. second, I asked if
> the kernel keep track of this structure, that is, it keeps a pointer
> on it for doing his job? according to your last answer, no. last
> question : why the size type of the first parameter of epoll_create is
> int and not size_t? no answer for the moment.

Why can't you ask all your questions at once?

The answer to your last one is in the manpage.  size_t, as
name suggests, is used for sizes of various memory regions,
in bytes.  Here, we're dealing with something else, not bytes.

And probably the next question will be of the sort why the argument
is named 'event' and not 'Event' or 'EventPtr', and why there's no
space after the star character...  Oh well.

/mjt
