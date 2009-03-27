Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbZC0XKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbZC0XKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZC0XKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:10:32 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57245 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZC0XKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OzoVt05w9OAxy/CumApMHaPt1WZIDBUuu6uoybYkbTyg1Rh0oPcw4HuTRjssbcSFCf
         6ZY3itMABb9I5vml4sE0b7SnV807xk1S8NMWW+p2MPqdhBhbpis7y1mWdAhc7C7IXcoj
         G7l8OlZ9UUp6CuLau0icRoshJ6Z9lW/53R9TY=
MIME-Version: 1.0
In-Reply-To: <49CD5AC6.3020806@msgid.tls.msk.ru>
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
	 <49CAA055.5060603@goop.org>
	 <84a01a8b0903251437l9f9059s3c548b5d35ea47d4@mail.gmail.com>
	 <84a01a8b0903270244s146ca50cr2758d36c2d9d77cd@mail.gmail.com>
	 <49CD4967.2090606@msgid.tls.msk.ru>
	 <84a01a8b0903271517t668c6276l7fe098d74c24b836@mail.gmail.com>
	 <84a01a8b0903271530of8d43ffhf77e7ba73e309f75@mail.gmail.com>
	 <49CD564E.6050101@msgid.tls.msk.ru>
	 <84a01a8b0903271555i7a4fea50nd95009539aa2f94d@mail.gmail.com>
	 <49CD5AC6.3020806@msgid.tls.msk.ru>
Date: Sat, 28 Mar 2009 00:10:28 +0100
Message-ID: <84a01a8b0903271610u17267f87u65b097ac2d755a52@mail.gmail.com>
Subject: Re: epoll_ctl and const correctness
From: nicolas sitbon <nicolas.sitbon@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is it stupid to ask how a size can be negative? who is stupid? you're
boring with my question, just tell me please how a size can be
negative?

2009/3/28 Michael Tokarev <mjt@tls.msk.ru>:
> nicolas sitbon wrote:
>>
>> Do you read my post? there is a confusion, my question was first : why
>> the structure isn't const? and you answer me. ok. second, I asked if
>> the kernel keep track of this structure, that is, it keeps a pointer
>> on it for doing his job? according to your last answer, no. last
>> question : why the size type of the first parameter of epoll_create is
>> int and not size_t? no answer for the moment.
>
> Why can't you ask all your questions at once?
>
> The answer to your last one is in the manpage.  size_t, as
> name suggests, is used for sizes of various memory regions,
> in bytes.  Here, we're dealing with something else, not bytes.
>
> And probably the next question will be of the sort why the argument
> is named 'event' and not 'Event' or 'EventPtr', and why there's no
> space after the star character...  Oh well.
>
> /mjt
>
