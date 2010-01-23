Return-Path: <linux-kernel-owner+w=401wt.eu-S1751650Ab0AWUZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab0AWUZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288Ab0AWUZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:25:33 -0500
Received: from mail-ew0-f226.google.com ([209.85.219.226]:45423 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab0AWUZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:25:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GAYDcHvbhnv9sIGbq0wZ+0QTQNAhPh5gtSPNo2DVqAMubT/L0TwVM1qDJUJYNZccPQ
         WaPDUjOKosIlJYCxlLsKFdWVqKdo38fsHCsrO5yYoDHfCBN64ZFuuYp/aHevKKe1hzQx
         zs8C/D7DrjQORjBzRQBtlN24f0UdBEj+fNqRo=
MIME-Version: 1.0
In-Reply-To: <201001232116.27003.rjw@sisk.pl>
References: <b4e196fa1001221721y19ae3a50wa21a6b54627b3852@mail.gmail.com>
	 <b4e196fa1001230322u558f7af5j5f27844088895a0@mail.gmail.com>
	 <20100123152421.GA15855@suse.de> <201001232116.27003.rjw@sisk.pl>
Date: Sat, 23 Jan 2010 15:25:30 -0500
Message-ID: <6041d2001001231225n303062f9hf6683f14551d2ff@mail.gmail.com>
Subject: Re: [REGRESSION] clockevents patch causes hang on power off
From: Marc Dionne <marc.c.dionne@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@suse.de>, Nathan Williams <ngwilliams@gmail.com>,
       "Ozan ??a??layan" <ozan@pardus.org.tr>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 23, 2010 at 3:16 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Saturday 23 January 2010, Greg KH wrote:
>> On Sat, Jan 23, 2010 at 10:22:10PM +1100, Nathan Williams wrote:
>> > 2010/1/23 Ozan ??a??layan <ozan@pardus.org.tr>:
>> > > Nathan Williams wrote:
>> > >> I'm having trouble with my PC crashing just as it's attempting to power off.
>> > >> I managed to git bisect to this commit:
>> > >>
>> > >
>> > > http://bugzilla.kernel.org/show_bug.cgi?id=15037
>> > > http://patchwork.kernel.org/patch/71537/
>> > >
>> >
>> > Thanks. The patch works for me.
>>
>> What's the plan on getting that patch into Linus's tree for .33?
>
> Well, I guess please send it to Linus with the appropriate CC list.
>
> This is a regression that we need to address ASAP, the patch is known, no
> one has objected, so the thing is pretty much clear.
>
> Rafael

I notice that it's been in tip timers/urgent and timers-for-linus for
a few days, in a slightly different form.

Marc
