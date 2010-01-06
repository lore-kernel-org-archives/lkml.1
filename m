Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777Ab0AFLWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab0AFLWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 06:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107Ab0AFLWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 06:22:53 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:3926 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab0AFLWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 06:22:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=O0dZ7Kuh9/fMf2Krk6bSD7nsrq6N2bfWjPylqwjAxaAEDAjYPC5GJBwP9VaJRi+i7f
         vzgvXsTJgWtw2VDHpba6jRJUsSxLXR5z4bf+X5W6s3tamDSC0rCEIgScUyqQWJztW3gt
         xJ/IYynNJlBes7zFafF+MGLPgDoasQ4vWNzGE=
MIME-Version: 1.0
In-Reply-To: <4B44684B.1060401@suse.cz>
References: <f17812d71001052226y604995a0m4c7887d29fd73f90@mail.gmail.com> 
	<4B445D3E.8080600@suse.cz> <f17812d71001060231l5c0ca1bha50e395790d0fc0b@mail.gmail.com> 
	<4B44684B.1060401@suse.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 6 Jan 2010 19:22:32 +0800
Message-ID: <f17812d71001060322j4970349ex52f0cfa495ac8628@mail.gmail.com>
Subject: Re: [PATCH] kbuild: include only necessary in scripts/Makefile.modbuiltin
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 6:39 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 6.1.2010 11:31, Eric Miao wrote:
>> On Wed, Jan 6, 2010 at 5:51 PM, Michal Marek <mmarek@suse.cz> wrote:
>>> On 6.1.2010 07:26, Eric Miao wrote:
>>>> scripts/Makefile.modbuiltin assumes either Kbuild or Makefile exists in
>>>> every sub-directory, which is not true.
>>>
>>> It assumes what there is a kbuild file in each directory listed in
>>> subdir-[ym] or obj-[ym]. For which directory is this not true? Did you
>>> see an actual build failure? The same include is used in
>>> scripts/Makefile.build, where it has been working fine for ages...
>>>
>>
>> Well, it's in my tree outside mainline, I have to make this change
>> to get it build. And'm wondering if that's a correct assumption.
>
> And scripts/Makefile.build does not fail? Strange. Can you point me at
> the tree so that I can have a look? I assume it's some branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6.git.
>

No, it's not within that tree.

And indeed it's strange - while scripts/Makefile.build doesn't fail since
there seems to be a script that generates some Makefiles in between
the build process, I'll get this figured out to see what is the root
cause.

> Thanks,
> Michal
>
