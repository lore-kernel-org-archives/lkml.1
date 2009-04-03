Return-Path: <linux-kernel-owner+w=401wt.eu-S1763199AbZDCA26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763199AbZDCA26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZDCA2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:28:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:19980 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZDCA2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bEM+zRgy4xmzRmPQdUPB0nWGzJg0dTXgrUKnrl5hGdylDG5R7nO3XoOqapXCId8CJh
         IdZRjbINrikS8zZ6Ud+lQHA66OR2a4AueJA3V+X+pfPZ9cOso8VGLu1MtQhX0s2CfKX+
         XMJ5NNsy1nGeXdqL+L6BDtClOqcu9i1Mq9j7Y=
MIME-Version: 1.0
In-Reply-To: <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com>
References: <49CCCB0A.6070701@nokia.com>
	 <alpine.DEB.2.01.0904021706330.6162@bogon.housecafe.de>
	 <9b1675090904021724t2fb0a671uc10d8e7bcba0bc5c@mail.gmail.com>
Date: Thu, 2 Apr 2009 18:28:47 -0600
Message-ID: <9b1675090904021728y35776377u327f2266d06e2f29@mail.gmail.com>
Subject: Re: EXT4-ish "fixes" in UBIFS
From: "Trenton D. Adams" <trenton.d.adams@gmail.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 2, 2009 at 6:24 PM, Trenton D. Adams
<trenton.d.adams@gmail.com> wrote:
> On Thu, Apr 2, 2009 at 6:09 PM, Christian Kujau <lists@nerdbynature.de> wrote:
>> On Fri, 27 Mar 2009, Artem Bityutskiy wrote:
>>> They just say - this is file-system bug, it is fixed in
>>> ext4 now, just fix the bug in UBIFS.
>>
>> Would *mounting* the filesystem with "-o sync" help? This way no
>> filesystem "fixes" are needed and userland would not have to be rewritten.
>>
>> Christian.
>
> Yes, mounting "-o sync" does improve ext3 performance.  It sucks
> though, because I do want quick writes.  And mounting with sync option
> slows down to disk io speeds.  In my case, that's between 20 and 23
> megabytes per second *big frown, quivering lip, and tears in my eyes*.
> :P
>

Oh, I should have clarified.  It improves performance under heavy
load.  Under normal load, mounting without sync is fine.  What I tend
to do is mount with "remount,rw,sync" when heavy load is starting.
Then my system goes slowly, but latency is good.  Then, when it's all
done (say a big compile, or job, or whatever), I remount without sync
again.

I'm thinking of writing a script that monitors performance, and
remounts as needed, lol.  WHAT A HACK. hehe.
