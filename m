Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZCYVh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZCYVh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZCYVhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:37:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:39506 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734AbZCYVhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:37:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GpCmaXHDSQNdL/n4z3ZEVfo+Rq/wi6ei8S2mJcJiOR0Y2PjCkDstqhu6/iQJzVsPiz
         Wl5Jt1q6Q6YkYmFPBCTpdjQDn8Vs58sSJp1efVb7Lcgt8tJdOh8XOZdD2C6AWyFZ+GL7
         jaMYullrVeajVRwfKlkMkFzH2tpTs+qsvJVnk=
MIME-Version: 1.0
In-Reply-To: <49CAA055.5060603@goop.org>
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
	 <49CAA055.5060603@goop.org>
Date: Wed, 25 Mar 2009 22:37:14 +0100
Message-ID: <84a01a8b0903251437l9f9059s3c548b5d35ea47d4@mail.gmail.com>
Subject: Re: epoll_ctl and const correctness
From: nicolas sitbon <nicolas.sitbon@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You don't teach me anything, I know that, the fact is the
documentation is incomplete, so rather saying that, please answer my
questions. For the moment, only the documenation and the prototype of
epoll are buggy.

2009/3/25 Jeremy Fitzhardinge <jeremy@goop.org>:
> nicolas sitbon wrote:
>>
>> valgrind confirms this
>> behaviour, so am I wrong?
>
> That doesn't prove very much.  Unlike usermode code, Valgrind doesn't
> instrument the kernel, so it computes the side-effects of kernel operations
> by parsing the syscall stream and simulating the effect.  (That is to say,
> it strengthens your argument somewhat, but valgrind's handling of this
> syscall could be buggy.)
>
>>  or the good prototype is
>>
>> int epoll_ctl(int epfd, int op, int fd, struct epoll_event const *event);
>>
>
> Putting "const" first is conventional.
>
>   J
>
