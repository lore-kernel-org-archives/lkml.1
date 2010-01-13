Return-Path: <linux-kernel-owner+w=401wt.eu-S932118Ab0AMTTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118Ab0AMTTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 14:19:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901Ab0AMTTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 14:19:09 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:35417 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab0AMTTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 14:19:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=J1dH6HAWs6EQmOOGNLcb6bbFxjvXKjna4uL7taEtm86wAyD9eXweL9zAuF4SHHlBS3
         4ilURYS6+4fnuGmmQFhDDJjp7p2UffZD+cFH7OoHNLOrhHC4YHiS3lIWIG5pu2vxULjd
         eqk9VYsvbu5PqnHbgKPZh+UW0ZpJ/GErTNyZs=
MIME-Version: 1.0
In-Reply-To: <20100113174446.GA20754@kroah.com>
References: <4B4DFD87.3000904@s5r6.in-berlin.de>
	 <Pine.LNX.4.44L0.1001131225160.3518-100000@iolanthe.rowland.org>
	 <20100113174446.GA20754@kroah.com>
Date: Wed, 13 Jan 2010 20:19:04 +0100
X-Google-Sender-Auth: f71584d30eda0462
Message-ID: <10f740e81001131119m54ec29b4x91786456d9eab062@mail.gmail.com>
Subject: Re: Changelog quality
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Julia Lawall <julia@diku.dk>, "N?meth M?rton" <nm127@freemail.hu>,
       David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, cocci@diku.dk,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 18:44, Greg KH <greg@kroah.com> wrote:
> On Wed, Jan 13, 2010 at 12:29:07PM -0500, Alan Stern wrote:
>> On Wed, 13 Jan 2010, Stefan Richter wrote:
>>
>> > If it was by mistake, inclusion of the find-and-replace script into the
>> > patch posting *after the --- delimiter* might have increased the chance
>> > that a patch reviewer becomes aware of a possible error source
>> > (inadequate match patterns...).  So that could be useful during review
>> > before commit, but not so much if the change is revisited some time
>> > after commit.
>>
>> Somewhat tangentially, it's worth mentioning that the comments
>> appearing after the "---" delimiter exist only in the original patch
>> submissions, not in the final commits.  Hence they are not available to
>> anyone reviewing the changes after acceptance.
>>
>> It would be nice if there was a way to link automatically a git commit
>> to an archived copy of the email message in which it was originally
>> submitted.
>
> Ingo has been doing this on some patches by putting a message-id field
> in the signed-off-by area showing what lkml message a patch came from.
>
> See git commit id 6432e734c99ed685e3cad72f7dcae4c65008fcab in Linus's
> tree as an example of this.
>
> I have no objection if people want to do this for any patches going
> through my tree as well.

While the idea behind this is definitely nice, I don't like the
current implementation: it's not really an `lkml reference', but just
the message ID of the email that contained the patch.
Which means it doesn't contain any reference to an lkml archive, but
instead it casts into `git-stone' the host and domain names of my
private machines at home ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
