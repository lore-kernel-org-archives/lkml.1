Return-Path: <linux-kernel-owner+w=401wt.eu-S1755448AbXFYQBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448AbXFYQBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 12:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXFYQBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 12:01:40 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:55134
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbXFYQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 12:01:39 -0400
Date: Mon, 25 Jun 2007 09:00:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>
cc: arnd@arndb.de, vapier.adi@gmail.com, schilling@fokus.fraunhofer.de,
       linux-kernel@vger.kernel.org
Subject: Re: Linux Kernel include files
In-Reply-To: <467fd9f3.Vc25RVyWdnB9qPjQ%Joerg.Schilling@fokus.fraunhofer.de>
Message-ID: <Pine.LNX.4.64.0706250858160.20356@asgard.lang.hm>
References: <467afc63.OnsqEXOk5zqMYzym%Joerg.Schilling@fokus.fraunhofer.de>
 <Pine.LNX.4.64.0706211620080.31603@asgard.lang.hm> <200706220159.07948.arnd@arndb.de>
 <467fd9f3.Vc25RVyWdnB9qPjQ%Joerg.Schilling@fokus.fraunhofer.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2007, Joerg Schilling wrote:

> Arnd Bergmann <arnd@arndb.de> wrote:
>
>> On Friday 22 June 2007, david@lang.hm wrote:
>>> this has been discussed many times and the answer is that the kernel is
>>> not gong to change it's side of things to ANSI C.
>>
>> I don't think that's entirely true with regard to the include files.
>> We have always tried not to step on anyone's toes there, e.g. regarding
>> the use of __u32 vs. uint32_t style types. It's certainly desirable
>> to make the kernel headers that are _meant_ for inclusion compatible
>> with standard compilers.
>>
>> Mike Frysinger has posted a few patches that make the installed headers
>> friendlier to strict C99 users. While there was some negative feedback
>> about these patches, it was not about the idea of making the installed
>> headers C99 clean, but rather about the question whether those non-clean
>> parts should be exported in the first place.
>
> Wouldn't it be simpler to ask the developers to deliver their include files
> in a state that is clean for user space programs?

that's what make headers_install does, as others have pointed out.

David Lang
