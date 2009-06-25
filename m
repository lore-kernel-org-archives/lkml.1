Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbZFYNZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbZFYNZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 09:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZFYNZC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 09:25:02 -0400
Received: from fifo99.com ([67.223.236.141]:45667 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbZFYNZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 09:25:00 -0400
Subject: Re: [PATCH 1/6] staging: android: binder: Remove some funny &&
	usage
From: Daniel Walker <dwalker@fifo99.com>
To: Dianne Hackborn <hackbod@android.com>
Cc: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Brian Swetland <swetland@google.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org
In-Reply-To: <26b7c7380906242109id89b490m2c148ec0ac9b3696@mail.gmail.com>
References: <1244832678-30329-1-git-send-email-dwalker@fifo99.com>
	 <4A390B9A.40806@goop.org> <1245254936.5982.261.camel@desktop>
	 <4A391A54.7000109@goop.org>
	 <d6200be20906171426n71979124i4b359b6f4fc35d7e@mail.gmail.com>
	 <1245274308.5982.268.camel@desktop>
	 <a55d774e0906191220i7280fe77qb724037fb92fab86@mail.gmail.com>
	 <1245451983.32124.25.camel@desktop>
	 <d6200be20906191713n161d4281u1f43804e675e29ac@mail.gmail.com>
	 <1245458940.32124.45.camel@desktop>
	 <26b7c7380906242109id89b490m2c148ec0ac9b3696@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 06:24:59 -0700
Message-Id: <1245936299.32124.299.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 21:09 -0700, Dianne Hackborn wrote:
> 2009/6/19 Daniel Walker <dwalker@fifo99.com>
> > Most of these questions related to the fact that I don't think an
> > interface like this just slips into the kernel as a driver. Since it's
> > IPC, it's totally generic, and it's not part of a standard (i.e. POSIX),
> > we need to have some better and more specific information about it (or
> > atleast I do).
> 
> Hi, sorry I have been slow to respond.  I can give a summary of how
> binder is used in the Android platform and the associated feature set.
>  I won't try to address other options, especially D-Bus, because
> honestly I haven't been following it for the last 3 or so years so
> don't really know its current state of art.

Thank your for the extensive response. I'm sure it will be helpful in
educating us as to the usage of the interface..

Was dbus initially investigated by the Android project as something that
could be used for IPC? Which other mechanisms had been investigated for
IPC beyond binder?

> I'm not sure what the relevance is of Java or C++ people liking it.
> Does this mean that the important thing is that C people love it and
> other languages don't matter? :)  Anyway whether or not you "love" it
> I don't think is a matter of programming language but just design
> style, personal preference, and who knows what else.  It has been
> extremely useful in our implementation of Android, as can be seen in
> just how much of the system sits on top of it, but that's all.

The important thing is that it's in the kernel for a better reason than
simply satisfying a certain language group ..

I think the biggest issue I have with the binder implementation is that
it's doing far too much in the kernel, it's not just IPC. It's also
thread management, memory management, and lots of other stuff that I
haven't figured out yet .. A lot of it can already be done in userspace.

Daniel

