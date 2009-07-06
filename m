Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbZGFRXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbZGFRXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 13:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbZGFRXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 13:23:37 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:44564 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504AbZGFRXg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 13:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=eK1Ve0ccePbRbrJ5l1KDlT4cwLQcerq4wdfznON3yI7w3cinkExhKOz3mrxkgJS2q6
         Yqs5PkGql1vwffdQqoZYfDehXx5UNH0qLlgfIa29b/g/3gcRs6CVeA5itzncVE+XMLvy
         dAhpB88LsMkf7d4983vEwH4JeMQ+hFyWfu/64=
MIME-Version: 1.0
In-Reply-To: <20090706163106.GA4559@ami.dom.local>
References: <200907031326.21822.andres@anarazel.de> <a5d9929e0907052153x2db851bcj26f1433c716c8a90@mail.gmail.com> 
	<20090706141916.GA3477@ami.dom.local> <200907061813.29379.andres@anarazel.de> 
	<20090706163106.GA4559@ami.dom.local>
From: Joao Correia <joaomiguelcorreia@gmail.com>
Date: Mon, 6 Jul 2009 18:23:18 +0100
Message-ID: <a5d9929e0907061023g4306d80ewfc8907653b949005@mail.gmail.com>
Subject: Re: Soft-Lockup/Race in networking in 2.6.31-rc1+195 ( 
	possibly?caused by netem)
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Arun R Bharadwaj <arun@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Since i already had the kernel compiled and ready to boot when i read
this, i gave it a go anyway :-).

I can reproduce the freeze with those 4 patches applied, so i can
confirm that its, at least, related to, or exposed by, those patches.
There must be something else too, or its just too much fuzziness, but
the freeze takes a bit more time (approximately five minutes, give or
take) compared to the instant freeze before, but its there with the
patches, and without them, no freeze.

I assume there isnt a "safe" way to get them out of current .31-rc's, right?

Thank you very much for your time,
Joao Correia


On Mon, Jul 6, 2009 at 5:31 PM, Jarek Poplawski<jarkao2@gmail.com> wrote:
> On Mon, Jul 06, 2009 at 06:13:29PM +0200, Andres Freund wrote:
> ...
>> > > Btw, I ran netem with delay for more than 48h on around 80mbit... That
>> > > does  not exclude such a rarely triggered race, but makes it a bit more
>> > > unlikely. (With migration thats around 3sec or so)
> ...
>> Sorry once more.
>
> Andres, the bisection + the above - you did 'the whole lotta work' and
> you shouldn't be sorry at all! ;-)
>
> Thanks again,
> Jarek P.
>
