Return-Path: <linux-kernel-owner+w=401wt.eu-S1758035AbYHZJz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbYHZJz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 05:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbYHZJyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 05:54:55 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:37867 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755044AbYHZJyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 05:54:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=D/rPnHhb2+U+8umYAMMUBlQGIOdFhONLkovPwtEOTgE19ioUHAO1WXwjSoRll/2VwLSeKOHZAaAYZQ0MCpZUW7hV3bRYHcmcfolTKlIONpNdMtThOaP478OQZFm9EGugxa6+mrj68hbyS3YvsPwkZsuZN3YVF5b+QLx5PJA71PQ=  ;
X-YMail-OSG: O0xnhhgVM1mQTzES0LxY7DTFZEwXo2wvkLEe12H3OfWRsO4HBkqAccUDZJ_JJQz3oB.3diMxtrwsfvlzxJNyKNfEeVmpRjR8fCV7_HyWBVxySYQX2qr6cUMXLEPFC.9t8hV_7nCCwyshC8s9p7BZzcz3
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Date: Tue, 26 Aug 2008 19:54:47 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080819103301.787700742@chello.nl> <200808261900.07383.nickpiggin@yahoo.com.au> <20080826093059.GA471@elte.hu>
In-Reply-To: <20080826093059.GA471@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808261954.47987.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 August 2008 19:30, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > So... no reply to this? I'm really wondering how it's OK to break
> > documented standards and previous Linux behaviour by default for
> > something that it is trivial to solve in userspace? [...]
>
> I disagree

Your arguments were along the line of:

* It probably doesn't break anything (except we had somebody report
  that it breaks their app)

* If it does break something then they must be doing something stupid
  (I refuted that because there are several legitimate ways to use rt
  scheduling that is broken by this)

* We have many other APIs and tools that don't conform to posix (why
  is that a reason to break this one?)

* We should break the API to cater for stupid users and distros who
  create local DoS and/or lock up their boxes (except this is trivial
  to solve by setting sysctls or having a watchdog or using sysrq)

So did I miss some really good argument, or do you really think the
above arguments are a good reason to break the API? If the latter,
then we have to just agree to disagree and I'll ask Linus to arbitrate.
OK?


