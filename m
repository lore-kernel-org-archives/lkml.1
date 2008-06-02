Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbYFBDZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbYFBDZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 23:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753917AbYFBDZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 23:25:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:41702 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbYFBDZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 23:25:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WOGxjTTTqPKW+MCA4v0A2HdfNhxwzeZx8wbDwwMo94jrxevOfLIkRXWqpIujbU34pr0nGcZCdQOKUY2acGtncEObecjI8YQlDWz5kz9EO6TkrJP36GEGSZKSVQ5W5F7nHr3OwVB7/jSlTR4+5NY8ZoNc0eKfcTH14aKmXPOMtYw=
Message-ID: <3aa654a40806012025ic6b9d0dlec05211bad782581@mail.gmail.com>
Date: Sun, 1 Jun 2008 20:25:19 -0700
From: "Avuton Olrich" <avuton@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my ALSA intel8x0 sound card regression
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Rene Herman" <rene.herman@gmail.com>,
       "Len Brown" <len.brown@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <4842CC50.4030406@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>
	 <4842CC50.4030406@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2008 at 9:20 AM, Rene Herman <rene.herman@keyaccess.nl> wrote:
> On 01-06-08 16:42, Avuton Olrich wrote:
>
>> My intel8x0 card stops working due to a regression; bisection and
>> information below.
>>
>> May have relationship to this thread
>>
>> http://groups.google.com/group/linux.kernel/browse_thread/thread/d5857287a36e71af/d7ae0a1490b7d142?lnk=st
>>
>> http://avuton.googlepages.com/intel8x0-config.gz
>> http://avuton.googlepages.com/intel8x0-cpuinfo
>> http://avuton.googlepages.com/intel8x0-dmesg
>
> This dmesg seems to be 6-byte file consisting of "dmesg\n" ...

Corrected:
http://avuton.googlepages.com/dmesg.txt

>> http://avuton.googlepages.com/intel8x0-ioports
>> http://avuton.googlepages.com/intel8x0-lspci-vvv
>> http://avuton.googlepages.com/intel8x0-modules
>> http://avuton.googlepages.com/intel8x0-ver-linux
>> http://avuton.googlepages.com/intel8x0-version
>>
>> commit 53052feb6ddd05cb2b5c6e89fb489bf83bbb6803
>> Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
>> Date:   Mon Apr 28 16:34:15 2008 -0600
>>
>>    PNP: remove pnp_mem_flags() as an lvalue
>>
>>    A future change will change pnp_mem_flags() from a "#define that
>>    simplifies to an lvalue" to "an inline function that returns the
>>    flags value."
>>
>>    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>>    Acked-By: Rene Herman <rene.herman@gmail.com>
>>    Signed-off-by: Len Brown <len.brown@intel.com>
>>
>
> I'm probably just really blind but I don't see how that specific commit may
> have made any difference. It _is_ in the exact spot which would fix that
> overlap problem of yours but this should be an identity change as far as
> fuctionality goes. Are you _really_ sure it's this one?
>
> (Is this racing with anything?)

I will confirm in the next 24 hours that the previous revision works.

Thanks,
-- 
avuton
--
 "I've got a fever. And the only prescription is more cowbell." --
Christopher Walken
