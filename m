Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbZC0Jof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbZC0Jof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 05:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZC0Jo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 05:44:26 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57505 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbZC0Jo0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ljJDfL+ix0OWRFkcXuEkvsYbnbwiJxzP3OQcQ2h7iOsvP4tlw30FPE2MOJGuC6uIcl
         LTyrjpIRRYxRVetUDGXRSU64BMOr5eZ5J11dFjl4XX2Gu50CpiZz1+SdG8n18ONxLoiX
         iQU8Kw6JHtvvqzvuOK7FOQ+y1vbp4aTrbGbOg=
MIME-Version: 1.0
In-Reply-To: <84a01a8b0903251437l9f9059s3c548b5d35ea47d4@mail.gmail.com>
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
	 <49CAA055.5060603@goop.org>
	 <84a01a8b0903251437l9f9059s3c548b5d35ea47d4@mail.gmail.com>
Date: Fri, 27 Mar 2009 10:44:23 +0100
Message-ID: <84a01a8b0903270244s146ca50cr2758d36c2d9d77cd@mail.gmail.com>
Subject: Re: epoll_ctl and const correctness
From: nicolas sitbon <nicolas.sitbon@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, can anyone answer me, I need a response.

2009/3/25 nicolas sitbon <nicolas.sitbon@gmail.com>:
> You don't teach me anything, I know that, the fact is the
> documentation is incomplete, so rather saying that, please answer my
> questions. For the moment, only the documenation and the prototype of
> epoll are buggy.
>
> 2009/3/25 Jeremy Fitzhardinge <jeremy@goop.org>:
>> nicolas sitbon wrote:
>>>
>>> valgrind confirms this
>>> behaviour, so am I wrong?
>>
>> That doesn't prove very much.  Unlike usermode code, Valgrind doesn't
>> instrument the kernel, so it computes the side-effects of kernel operations
>> by parsing the syscall stream and simulating the effect.  (That is to say,
>> it strengthens your argument somewhat, but valgrind's handling of this
>> syscall could be buggy.)
>>
>>>  or the good prototype is
>>>
>>> int epoll_ctl(int epfd, int op, int fd, struct epoll_event const *event);
>>>
>>
>> Putting "const" first is conventional.
>>
>>   J
>>
>
