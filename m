Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZI1Uj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZI1Uj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZI1Ujz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:39:55 -0400
Received: from mail-yx0-f173.google.com ([209.85.210.173]:56838 "EHLO
	mail-yx0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbZI1Ujy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:39:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=I10E2he68F3nd53UWjtX6fpV3Byza2ogxf3W7dY1qJ6Fu8Tcr8lAm9OgnDLGs+LAqZ
         7zz7z0TkE5lnMwiZflTCNbDMEHo+ctbOf3sYHNTkT1hL99yHJJfBWI4SUbXzudtTOEFj
         s/c+g43E2Oua4Ma0v77ZzwESgjJeqKbAzV0pY=
MIME-Version: 1.0
In-Reply-To: <20090928080729.GB6793@console-pimps.org>
References: <1253888440-14111-1-git-send-email-matt@console-pimps.org> 
	<8bd0f97a0909251000y3316891dh4d09744ed98139e8@mail.gmail.com> 
	<20090928080729.GB6793@console-pimps.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 28 Sep 2009 16:39:38 -0400
Message-ID: <8bd0f97a0909281339p1abe6ff0h1ef4e05887a2413d@mail.gmail.com>
Subject: Re: [PATCH] lib/checksum.c: Fix another endianess bug
To: Matt Fleming <matt@console-pimps.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 28, 2009 at 04:07, Matt Fleming wrote:
> On Fri, Sep 25, 2009 at 01:00:25PM -0400, Mike Frysinger wrote:
>> On Fri, Sep 25, 2009 at 10:20, Matt Fleming wrote:
>> > From: Matt Fleming <matthew.fleming@imgtec.com>
>> >
>> > This fix allows the generic checksum code to work on my little endian
>> > system. The previous fix was not enough, as "buff" is a big-endian
>> > value. Without this patch I see malformed TCP packets.
>>
>> can you try this one ?
>> http://lkml.org/lkml/2009/6/23/597
>
> Yep, that one works fine also. Thanks, Mike. Who's going to pick this
> up? I'm guessing this commit is also applicable for stable? Though, I
> don't know if there are any little-endian users of this code in stable.

i'm converting Blackfin to it now that the LE issues should be fixed,
but i'm going to hold off on pushing the change until it can be tested

as for picking up the fix, let's ask Andrew ...
-mike
