Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYJNWHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYJNWHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYJNWHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:07:25 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:17558 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840AbYJNWHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=woNdMT+mMuLiqUHX4wTJTtPMlYdEbwYgU0IJIbgRdR3+pDVDREhvkgu0O9kBa7fbbc
         ttUkM3v2/0Q/nJgtW7scf6fKmaZxZL85px47gTOeheMfWKWs9tHE1+IN8R5//TYeMZrE
         tWEWCSoFAYRUJ5X2dYWOPKBnRAvi0jgPFgJhI=
Date: Wed, 15 Oct 2008 02:10:19 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Kaz Kylheku <kkylheku@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: GPL question: using large contiguous memory in proprietary
	driver.
Message-ID: <20081014221018.GA1498@x200.localdomain>
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 02:56:40PM -0700, Kaz Kylheku wrote:
> I have the following question. Suppose that some proprietary driver
> (otherwise completely clean, based only on non-GPL symbols)

You have strange notion of "clean".

> requires a large buffer of physically contiguous memory.
> 
> A GPL-ed driver could get this memory by having some boot-time
> code compiled into the kernel which calls bootmem_alloc during
> kernel initialization. This function would stash the address of the
> memory into some global variable which is exported for the
> module to use.
> 
> How do you solve this problem in a proprietary driver?

:-)

> It seems
> like the above solution taints the kernel, because the kernel
> provides a symbol which exists only for the sake of supporting
> a proprietary driver.
> 
> Would it be okay to have a mechanism like this:
> Suppose that  on the kernel command line, you could
> request a boot-time memory allocation and give it a name.
> For instance, the parameter:
> 
>    boot_alloc=foo,8192K
> 
> would create an 8192 kilobyte allocation, and associate it
> with the string "foo".   A non-GPL function would be provided to
> find the address of this memory, using the string "foo"
> as the key. The proprietary driver would document the
> requirement that it needs a memory region of at least
> 8192K, under the name "foo".
> 
> Help! :)

Since the code to reserve memory and code to find by name won't be
accepted, the question is rather pointless.
