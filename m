Return-Path: <linux-kernel-owner+w=401wt.eu-S1758429AbZEANTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758429AbZEANTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZEANTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:19:11 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:47198 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZEANTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:19:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZHZoPdb4BWT89CFRWUWmbTR/bse5ZdxB22xQNaDqjMFKD5K1bxAX6FrNOZaa8foqsn
         T3jXdoK4xYZXIg5MS9vodDs5eJMlymDHXavjZRgWmK5lfkzqyYzqQtcOYs7Zeq1uo01D
         N5RVYTiR/39zQb/abRyi9e16TKEb4fkb7czsg=
MIME-Version: 1.0
In-Reply-To: <1241165805.13562.2.camel@johannes.local>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>
	 <1241165805.13562.2.camel@johannes.local>
Date: Fri, 1 May 2009 09:19:08 -0400
Message-ID: <f7848160905010619n74372488n45a7b7abccfe5ea7@mail.gmail.com>
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
From: Parag Warudkar <parag.lkml@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/1/09, Johannes Berg <johannes@sipsolutions.net> wrote:

> I'm not sure what makes you think that it even _should_ be reverted.
>  Just to make that clear: it should _not_ be reverted. How did you check
>  that it isn't reverted in compat-wireless anyway? Must have been by code
>  inspection since if you had made an attempt to verify that the code in
>  there works, you would have found that indeed there's no reason to
>  revert this commit since the fix for it went in, and is literally a
>  single line.

Well I have the 04-29 compat-wireless tree and it does not work - just
like mainline I get timeouts. I have not been able to download later
versions - clicking on the URL does nothing for some reason. (Besides
I do not normally track compat-wireless.)

So since I wasn't able to use the mainline for 2-3 days and I could
not find any regression/bug where it was mentioned the bug was fixed
in compat-wireless I thought it might be better to revert it until a
fix appears. (BTW, I just did a pull on Linus tree and the fix hasn't
made it there).

So unless I am being too unreasonable here I think reverting *was*
(not *is* of course now) the right thing to do based if nothing else,
on the fact that ath9k and iwlagn were unusable for 2+ days and not
everyone can be expected to run compat-wireless daily builds.

Any way now that we know there is a fix - I will wait for it to appear
in mainline.

Parag
