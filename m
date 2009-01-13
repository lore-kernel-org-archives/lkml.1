Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZAMHEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZAMHEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 02:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbZAMHEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 02:04:00 -0500
Received: from rv-out-0506.google.com ([209.85.198.236]:60198 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZAMHEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 02:04:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d2Ot8Pp1+gWLgN+kYPediOaO6UeTb7X+9JlUvLCxdBJf+zh2aZsEix6X1Vj2v2WNSF
         xbtTalJwlybJ5HSm3HG1hVzKf8wB+0dWYBN5HNHhI3xLBoDs/iaf4oZ4q2WObETDC/RD
         ZZ6LcwX+vslRUgsUiD9GWvQdqSkei230J1NZU=
MIME-Version: 1.0
In-Reply-To: <20090112213719.GC7320@elte.hu>
References: <20090112212855.GB15185@uranus.ravnborg.org>
	 <1231795863.5405.8.camel@brick> <20090112213719.GC7320@elte.hu>
Date: Tue, 13 Jan 2009 12:33:59 +0530
Message-ID: <3f9a31f40901122303m4e37c33ag5b308eb538d4e60b@mail.gmail.com>
Subject: Re: Can we get warnings from the x86 userspace headers fixed?
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 3:07 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
>
>> On Mon, 2009-01-12 at 22:28 +0100, Sam Ravnborg wrote:
>> > Hi Ingo.
>> >
>> > We have recently introduced a lot of new warnings for our
>> > userspace headers.
>> >
>> > Try to do a "make headers_check" and enjoy...
>> >
>> > Are there any chance you could ask one of your helpers to
>> > start to look into the x86 specific ones?
>> >
>> > If we get x86 clean this would create more incentive to
>> > make the generic clean too.
>> >
>> > I had originally planned to attack the generic headers
>> > (include/linux/*) but I'm faced by reality after my
>> > vacation and has almost no spare time for the time being.
>> >
>> > I already fixed the sparc headers but that is not
>> > visible compared to x86 (the fixes was btw easy).
>> >
>> > I can try to help by doing a few reviews in the
>> > beginning but I need to fix kbuild stuff first where
>> > I have a few serious issues pending. And lacks time...
>> >
>>
>> I'll have a go at some of them this afternoon unless someone beats me to
>> it.
>
> thanks Harvey! Please work against tip/master if you do that, there's a
> few header file changes in the queue already.
>

Some patches are also available in:

http://git.kernel.org/?p=linux/kernel/git/jaswinder/linux-2.6-tiptop.git;a=summary

Thanks
--
JSR
