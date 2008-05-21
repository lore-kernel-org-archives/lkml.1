Return-Path: <linux-kernel-owner+w=401wt.eu-S935508AbYEUOek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935508AbYEUOek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934755AbYEUOeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:34:00 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:57936 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934485AbYEUOd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lRlmVftDjB+liZ/6KvGYrMgx77FM5yQmYKTnHxomYxb3yMw6j7HTiADpQC+hamu/9O+C4wgUge/xD13Co5tTmJl52m4Ms0bPCmHNhpNFb8e4QV6BizMCC8nHX7zYXQbfVz3bL8Oe3pbbzbcxTBqoqykJ9f211uJWuggnV9wnWeM=
Message-ID: <dd18b0c30805210733m6d853709xf59331cfed3bfea@mail.gmail.com>
Date: Wed, 21 May 2008 14:33:57 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: completely lost as to what to do, or where to look.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080521075917.GB18352@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805202110x7c412b3bq523f91d968072482@mail.gmail.com>
	 <20080520223410.9a8f200d.akpm@linux-foundation.org>
	 <dd18b0c30805202351h133147adg5bb526e3f74e3bd6@mail.gmail.com>
	 <20080521075917.GB18352@cs181133002.pp.htv.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 7:59 AM, Adrian Bunk <bunk@kernel.org> wrote:
> On Wed, May 21, 2008 at 06:51:24AM +0000, Justin Mattock wrote:
>> On Wed, May 21, 2008 at 5:34 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Wed, 21 May 2008 04:10:16 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:
>> >
>> >> Hello; I'm lost as to where to look in the kernel, as to why I'm
>> >> receiving a black screen with startx
>> >> DRI seems to be fine, I'm noticing a sema_init but am not sure if this
>> >> is the cause of the blackness.
>> >> any direction as to where I might look would be helpful.
>> >
>> > Kernel version?
>> >
>> > A git-bisect should get you down the the offending commit within an
>> > hour or three.  http://www.kernel.org/doc/local/git-quick.html has some
>> > instructions.
>> >
>> > But if you're on 2.6.26-rcX, be sure to use the very latest - a pile of
>> > bad DRI code got reverted recently.  This morning, I think.
>> >
>>
>> Thanks for the help, From what I can remember I noticed this around
>> 2.6.26-rc1. It could be an issue with DRI, but then again it could be
>> something else. With running some more tests I'm noticing  a conflict
>> with libdri.so, not recognizing the module or the module not
>> recognizing libdri.so.
>>...
>
> Which X video driver are you using?
>
> What exactly is the error message?
>
>> regards;
>> Justin P. Mattock
>
> cu
> Adrian
>
> --
>
>       "Is there not promise of rain?" Ling Tan asked suddenly out
>        of the darkness. There had been need of rain for many days.
>       "Only a promise," Lao Er said.
>                                       Pearl S. Buck - Dragon Seed
>
>

Hello; thanks for the feedback, from previous posts, you know what
module I'm talking about, So with that in mind I'm going to go
to the next question: From error messages "there isn't"
the only leeway or light at the end of the tunnel I see is with
libdri.so i.g. If I boot the system up with out messing with anything
I will receive
a black screen after issueing startx, (from looking at what I see, the
screen will flash one time then black, it should flash or blink two
times
before giving me my lovely picture(wallpaper) then if I remove
libdri.so everything starts up as usual so with that in mind since I
received
a post about DRI being all F*&^ked up then maybee that is the culprit,
I think All I really need right now is info on the xserver and the
kernel.
What mechanisms are used or files that are responsible for the two too coexist.
regards;

-- 
Justin P. Mattock
