Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZC0Tnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZC0Tnj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbZC0TnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:43:23 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58283 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbZC0TnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:43:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TN9nm6RjwUQCyknuTEW24lqxcSj5mgXjqmEXrTRc1IwrPiwq++HL0g8mlwgRc55Rmi
         Q3QLU/Da5c1pk2ix6oOKcAFujaOC5V3FHYhO6UgSmzmeX7VxW4wvi3qUWrTknM1nvM7t
         x7ilDPlyr+CKXmJCRoKnfkciZS5/dJy8UCKwg=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0903250921230.15216@makko.or.mcafeemobile.com>
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
	 <alpine.DEB.1.10.0903250921230.15216@makko.or.mcafeemobile.com>
Date: Fri, 27 Mar 2009 20:43:17 +0100
Message-ID: <84a01a8b0903271243p60cee9fbn725cfe1118e9642d@mail.gmail.com>
Subject: Re: epoll_ctl and const correctness
From: nicolas sitbon <nicolas.sitbon@gmail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to this link : http://lse.sourceforge.net/epoll/index.html,
you're are the author of epoll, so please can you answer my questions.
TBA.

2009/3/25 Davide Libenzi <davidel@xmailserver.org>:
> On Wed, 25 Mar 2009, nicolas sitbon wrote:
>
>> Currently, the prototype of epoll_ctl is :
>>
>> int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
>>
>> I searched in the man of epoll_ctl and google, and it seems that the
>> structure pointed to by event isn't modify, valgrind confirms this
>> behaviour, so am I wrong? or the good prototype is
>>
>> int epoll_ctl(int epfd, int op, int fd, struct epoll_event const *event);
>
> According to the current ctl operations, yes. But doing that would prevent
> other non-const operations to be added later on.
>
>
> - Davide
>
>
>
