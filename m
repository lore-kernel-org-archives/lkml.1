Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbZKDOZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbZKDOZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbZKDOZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:25:24 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:50391 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbZKDOZV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:25:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=lrJCR/pNMxAPC1+f251dfQcnO04IbhOQys4i0xap7GH//9FxuXoL0sUaoO7bv0f+kM
         IfR7eDTdaSP//wmN9s6g4IjhR6tjbJHcotK9YDwyajVQvFMUPTz8CSV9pZ/iIo9Y7c7p
         8g20uD2eza0xRb9+VbHyE8a3jE04D+VhRjld8=
MIME-Version: 1.0
In-Reply-To: <20091102192706.GA30939@elte.hu>
References: <b8bf37780911020926p77ca30d1maa4384f21323adb@mail.gmail.com> 
	<20091102192706.GA30939@elte.hu>
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Wed, 4 Nov 2009 12:25:05 -0200
Message-ID: <b8bf37780911040625r3fe0d18dx4f74c7be54f5dc3@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] vsprintf: factor out skip_space code in a separate 
	function
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, laijs@cn.fujitsu.com,
       davem@davemloft.net, akpm@linux-foundation.org,
       harvey.harrison@gmail.com, linux list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo!

On Mon, Nov 2, 2009 at 5:27 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * André Goddard Rosa <andre.goddard@gmail.com> wrote:
>
>> >From 584d9bfc7c1d41b76a05655b4562b98fcbef6ee4 Mon Sep 17 00:00:00 2001
>> From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
>> Date: Sun, 1 Nov 2009 14:09:06 -0200
>> Subject: [PATCH v2 7/7] vsprintf: factor out skip_space code in a
>> separate function
>> MIME-Version: 1.0
>> Content-Type: text/plain; charset=UTF-8
>> Content-Transfer-Encoding: 8bit
>
> btw., for reviewability's sake, could you please fix your patch
> submission method to not include such garbled headers in the mail body?
>
> (Also, it would be nice to reply-thread the 7 patches on the 0/7 mail,
> as git-send-email does.)
>

I had some discussion about these headers on git mailing list (
http://marc.info/?t=125726599400002&r=1&w=2 ).

So, I'd like to know if it's preferred to remove all these headers
altogether or leave them by just removing the
commit # line and fixing the "From: " line.

What do you think?

p.s.: I'll probably use git-send-email in a second moment -- have to
fix my environment first
https://bugzilla.novell.com/show_bug.cgi?id=525780

Thanks,
André
