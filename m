Return-Path: <linux-kernel-owner+w=401wt.eu-S1762953AbYESUXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762953AbYESUXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 16:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757446AbYESUXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 16:23:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:23525 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762192AbYESUXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 16:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m/2vl1z063Hp9FB+VScyhdksRkRsLTAggvLTIOAI7vblez9lWUJ3EZnih0qJZt7m8ynOcB8FVLHjF02J0ZC4TPu9gkxbtKfiq0ThQ0xN2Nx1T2AWnxMFuxcCkIf4MfebN0rRG33ximKCRkVvCu27+l/Fo26jPX2hQfqLck9nTM4=
Message-ID: <19f34abd0805191323o17e9411btde5a0fa02597d7fc@mail.gmail.com>
Date: Mon, 19 May 2008 22:23:02 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] decodecode: use cross-compiler/toolchain if defined
Cc: "Randy Dunlap" <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080519190256.GA24599@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080512135242.GA5014@damson.getinternet.no>
	 <20080519190256.GA24599@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 9:02 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Mon, May 12, 2008 at 03:52:42PM +0200, Vegard Nossum wrote:
>>
>> From 75166add6121dbda4fad2e197d4fe6525dee580c Mon Sep 17 00:00:00 2001
>> From: Vegard Nossum <vegard.nossum@gmail.com>
>> Date: Mon, 12 May 2008 15:36:38 +0200
>> Subject: [PATCH] decodecode: use cross-compiler/toolchain if defined
>>
>> From the Makefile: "CROSS_COMPILE specify [sic] the prefix used for all
>> executables used".
>>
>> This is also very useful for decoding oopses on other archs than the
>> native one, so it seems natural to have it in the decodecode script as
>> well.
>
> I agree with the intent of this patch.
> But as it is my experience that most people use
> CROSS_COMPILE on the commandline and not as an
> environmnet variable most will not benefit from this patch.

I do use it on the command line too, it just has to come in front of
the 'make' command:

CROSS_COMPILE=x86_64-linux-unknown-gnu- make

> We should as a minimum document this use of decodecode where we
> document its usage today (oops-tracing.txt).
>
> We could also make it a Makefile target thus it is a bit
> more natural to supply the typical Makefile parameters?
>
> Please rework one way or the other.

I can try to do both those, however I don't see how this patch fails
to be an improvement in any case.

Thanks for the feedback.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
