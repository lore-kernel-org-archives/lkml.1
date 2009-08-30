Return-Path: <linux-kernel-owner+w=401wt.eu-S1753928AbZH3R3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbZH3R3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 13:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbZH3R3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 13:29:21 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:61293 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZH3R3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 13:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=UCqeNsheWqi9OjI8Y1TGI+jtVNq6ApNJyWV4zH9VimVxu8IhsorTW4xkJgvyNS+mj7
         crIPuYHhypUFMYPjCIjBHilmXe1NjnekOcvZRbIhB51Sagavs59KEyioSyihB26WULJr
         spVsQumdhGo+fMl7xZUuPxlIQU6ZuazJ3wvck=
MIME-Version: 1.0
In-Reply-To: <20090830171749.GA8642@mit.edu>
References: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com> 
	<tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com> <20090830163417.GA15183@skywalker.linux.vnet.ibm.com> 
	<20090830171749.GA8642@mit.edu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 30 Aug 2009 10:29:01 -0700
Message-ID: <43e72e890908301029t71a9c1a2t3d17e99cf3112ad2@mail.gmail.com>
Subject: Re: memleaks, acpi + ext4 + tty
To: Theodore Tso <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 30, 2009 at 10:17 AM, Theodore Tso<tytso@mit.edu> wrote:
> On Sun, Aug 30, 2009 at 10:04:17PM +0530, Aneesh Kumar K.V wrote:
>> > The ext4 reports are real leaks and patch was posted here -
>> > http://lkml.org/lkml/2009/7/15/62. However, it hasn't been merged into
>> > mainline yet (I cc'ed Aneesh).
>>
>> The patch is part of ext4-patchqueue  http://repo.or.cz/w/ext4-patch-queue.git
>>
>> Any plans to push the patches to linus tree soon ?
>
> Yes, as soon as the next merge window opens.  The leak only shows up
> when you mount and unmount a filesystem, which under normal
> circumstances doesn't happen a huge number of times on most systems.
> By the time it showed up it was late enough in the 2.6.31-rcX series
> that I figured it was better to wait until the next merge window.  I
> didn't consider it a high priority bug.

That's odd I run into this kmemleak with a single bootup, no manual remounts.

  Luis
