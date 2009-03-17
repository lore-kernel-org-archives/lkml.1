Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbZCQPPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbZCQPPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbZCQPPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:15:13 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:25912 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbZCQPPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:15:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fmHV4cWvdqF2fyHaPRIO8WQUen2tscGJYSmMpz9fAyHKU8PB1igW/eOM0bMPtvnTwq
         Y2Uln6Esb6LoJY2qq7tbTT/WB0x2HEiy5Wdd8ey/pyGVfzIqo25jYrAHJZIK1QsokEDz
         7lCkwrSanuGQenovC0zQpCZ6FWU+KTBkmudJs=
MIME-Version: 1.0
In-Reply-To: <20090314161341.GB1496@ucw.cz>
References: <20090311200411.WPUP4619.eastrmmtao102.cox.net@eastrmimpo02.cox.net>
	 <20090314161341.GB1496@ucw.cz>
Date: Tue, 17 Mar 2009 11:15:09 -0400
Message-ID: <3aaafc130903170815x7704d9f0gdb6012bbf63e2a5b@mail.gmail.com>
Subject: Re: [PATCH] /dev/time for Linux, inspired by Plan 9
From: "J.R. Mauro" <jrm8005@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Christopher Brannon <cmbrannon@cox.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 12:13 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Wed 2009-03-11 10:10:23, Christopher Brannon wrote:
>> Under Plan 9 from Bell Labs, one queries or sets the system clock by
>> reading or writing text strings to a special file named /dev/time.
>> I implemented such a facility for Linux.  A read of /dev/time produces
>> four decimal numbers: epoch seconds, nanoseconds since start of epoch,
>> nanoseconds since boot, and nanoseconds per second.  Writing a
>> decimal number
>
> nanoseconds per second?! Just use 123.456 notation.

The point is to be close to Plan 9's interface, in which column 3 is
"something since boot" and column 4 is "somethings per second" to keep
programs portable.

>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
