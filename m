Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348AbYJNXUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbYJNXUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 19:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbYJNXSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 19:18:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:11238 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbYJNXSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 19:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=b2S4Ucj2uDQOhW7zlBQIjFvSXDbbmrDQkajk44zSikx8M/laUaS6HZNcIt3BqCqUlO
         7zwzvNBDtvBevezXklt3vK8ypaWcfL5Es3pHxJG1FKg1edNMExUW5L82OUaSYd1hnWLq
         v/ihd6hfL+SFhwHcV7BHhRMXhBwE16Zvam0YU=
Message-ID: <3f43f78b0810141618s64dbeeeew82b41f100890bb5f@mail.gmail.com>
Date: Tue, 14 Oct 2008 16:18:50 -0700
From: "Kaz Kylheku" <kkylheku@gmail.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: GPL question: using large contiguous memory in proprietary driver.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081014221018.GA1498@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
	 <20081014221018.GA1498@x200.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 3:10 PM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Tue, Oct 14, 2008 at 02:56:40PM -0700, Kaz Kylheku wrote:
>> Would it be okay to have a mechanism like this:
>> Suppose that  on the kernel command line, you could
>> request a boot-time memory allocation and give it a name.
>> For instance, the parameter:
>>
>>    boot_alloc=foo,8192K
>>
>> would create an 8192 kilobyte allocation, and associate it
>> with the string "foo".   A non-GPL function would be provided to
>> find the address of this memory, using the string "foo"
>> as the key. The proprietary driver would document the
>> requirement that it needs a memory region of at least
>> 8192K, under the name "foo".
>>
>> Help! :)
>
> Since the code to reserve memory and code to find by name won't be
> accepted, the question is rather pointless.

Suppose that this problem is being solved by people who maintain
their own OS distribution, based around a customized Linux kernel,
targetting a very specific piece of hardware, manufactured by
them.

So there is no situation in which users of a mainstream
distribution would be asked to patched their kernels to
be able to use this driver.   Their kernels would already
come that way from this distribution.

The driver in question is specific to the hardware, and uses code
licensed from the vendor of some chips that are used on the
embedded system, so the developers don't have the option of
open-sourcing it, however attractive that might be.
