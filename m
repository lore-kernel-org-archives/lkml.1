Return-Path: <linux-kernel-owner+w=401wt.eu-S1757943AbXGAQZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943AbXGAQZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 12:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbXGAQZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 12:25:42 -0400
Received: from wx-out-0506.google.com ([66.249.82.232]:50331 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbXGAQZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 12:25:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y4FmkNO2EAAQundS62NRV0XULa/v8ZloiZwXebsFxUy+5OkhhB2Z2ErU2tRsBZ0Nw+Vszq9v3bHw/FOiPQ8AvLHXPEnB9oEXQC3rmXfdoI7ilB46eGYraGZvpUP/C8vnwKA+ljlKOSzk93Z5hxHWLh9Jl1Eb9Cz3b6bY+bkOt2k=
Message-ID: <a36005b50707010925k5c936c1ch2238b560c595a833@mail.gmail.com>
Date: Sun, 1 Jul 2007 09:25:40 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 0/6] sys_indirect RFC - sys_indirect introduction
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0706301529310.2957@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <send-serie.davidel@xmailserver.org.28360.1183153732.0>
	 <a36005b50706291848p406fbb9aw99697f609b0d5c4b@mail.gmail.com>
	 <Pine.LNX.4.64.0706301208140.2957@alien.or.mcafeemobile.com>
	 <a36005b50706301454j46c23760m5f0ac6088fe24a9d@mail.gmail.com>
	 <Pine.LNX.4.64.0706301458300.2957@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0706301529310.2957@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/30/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> This is how all those overloaded syscalls looks like, BTW:
> [...]
> How would you do that with a single shared strcture, w/out adding in all
> signal paths the knowledge of the structure?

You said it yourself: each individual wrapper would look like this.
Generalization really isn't possible, you'll have each wrapper syscall
looking different.  This means there is no reason to try coming up
with some overly complicated data structure which would only be useful
if the processing of that data structure could be centralized.
