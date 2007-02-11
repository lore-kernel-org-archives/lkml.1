Return-Path: <linux-kernel-owner+w=401wt.eu-S932430AbXBKUJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbXBKUJT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 15:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932425AbXBKUJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 15:09:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.233]:32742 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932534AbXBKUJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 15:09:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eDI23Oy5N6XZHtXd8C5l+sQKmhTwJ97+C1B5pZHZg3VlC8ppa34Ih4x13LVuxDc0nGhAA5xW5QaIVXGl5Ci2VkirKs93APdXivmw3nAU+n6HlWokop7x8mAc7u6UEzM/P/piNkyjnRYLaNa0zBS691ixItmYB+tuhzdLg1vuv2o=
Message-ID: <8d158e1f0702111209u1ba462a9se155d37d4ce3c44e@mail.gmail.com>
Date: Sun, 11 Feb 2007 21:09:14 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: libsata doesn't like bus without master
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070211195846.GC26874@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.OcrmlkSFqen95BGHXWJdR6KGswQ@ifi.uio.no>
	 <fa.mIV6AQH7D5yiY39XNxbu0M2/1Kc@ifi.uio.no>
	 <fa.3Ti1gtH2JY4DWsqr3J1loC7lcc0@ifi.uio.no> <45CF619D.6000704@shaw.ca>
	 <20070211195846.GC26874@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/11/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Sun, 11 Feb 2007, Robert Hancock wrote:
> > Then in that case you should set the remaining drive as master. That's
> > just the way PATA is. A lot of BIOSes won't even detect a drive that's
> > set as slave with no master present.
>

> For some stupid reason, it appears that the norm around here (Brazil) is
> that "no brand" boxes get assembled with ATAPI devices in slave mode.
> Usually they attach it to the second channel using an 40-wire cable, even if
> there is nothing using the first channel.

Yes, this is actually one of the reasons i mentioned sometimes having
only a slave drive can be a "legal" way to connect drives. I've lived
in Curitiba and Rio for a while (familiar cities to you I guess) and
sometimes we just had no choice to yank the master drive out of its
bay and keep running with what we had, cause money wasnt exactly
growing in trees where I used to work.

Next to that, we had the so called "paraguay" quality assembled
hardware, which basicly means someone, somewhere put some hardware
together and if it didnt work, you had a problem since its all you
could get.

Now, I agree with Robert, people should assemble and maintain their
hardware as much as possible, following the specs. But sometimes it
just isnt possible to do that, for whatever the reason might be. And I
honestly havent found any old or new mainboard that doesnt allow you
to have only a slave drive. I did see the opposite tho. A master drive
that just refused to get detected cause the jumper wasnt set to
"master only" (hello Western Digital).

I don't know, the error i saw is nothing critical, I am just wondering
how valid the "abnormal" notation is, if you go by the specs of ATA,
yes, it is. If you go by daily practice, then in my honest opinion, it
isnt.

Then again, there are way more important things to deal with right now
than cosmetics :)


Patrick
