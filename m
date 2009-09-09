Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZIIRpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZIIRpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:45:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbZIIRpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:45:06 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:62924 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbZIIRpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:45:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xdmGp+KKj9FWUCwCau4FveUl5jUk+nZOAu1a+GKs2SXQnS6lvkdgC3RsMDTj8mqL+b
         TIwGAkwTypzZPHdTiX7mFTyb0Zxc9kNPkzwRfoDd1nk4UjCkDjPQZjKT6sIoROVAw/5h
         4H3QvJLLXxF5PUCmHkHwhe2RIhzfOu4JkHAz8=
MIME-Version: 1.0
In-Reply-To: <4AA7C38E.8020306@redhat.com>
References: <4AA5E5F3.30309@primeinteractive.net>
	 <4AA72C14.1020005@primeinteractive.net>
	 <alpine.LRH.2.00.0909091141300.25928@twin.jikos.cz>
	 <4AA7C38E.8020306@redhat.com>
Date: Wed, 9 Sep 2009 10:45:06 -0700
Message-ID: <150c16850909091045h1962fd67n77c265c9b99c5f44@mail.gmail.com>
Subject: Re: ext4+quota+nfs issue
From: Justin Maggard <jmaggard10@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
       Pavol Cvengros <pavol.cvengros@primeinteractive.net>,
       linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       linux-ext4@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 9, 2009 at 8:02 AM, Eric Sandeen<sandeen@redhat.com> wrote:
>> On Wed, 9 Sep 2009, Pavol Cvengros wrote:
>>
>>> Hi,
>>>
>>> can somebody who is aware of ext4 and quota have a look on this one?
>>>
>
> This was also just reported at:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=521914
>
> -Eric
>

I've seen exactly the same thing myself as well, but on local I/O.
The only difference I was able to find between filesystems I saw this
on, versus filesystems that I didn't see this on, was how it was
created.  The filesystems without this issue were made using
mkfs.ext4, and the ones that _did_ have the issue were created with
mkfs.ext3, and then mounted -t ext4.  Pavol, can you check your
filesystem features from "dumpe2fs -h [your_device]"?

-Justin
