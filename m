Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbYISDBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbYISDBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 23:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYISDBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 23:01:41 -0400
Received: from mail.atheros.com ([12.36.123.2]:39769 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944AbYISDBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 23:01:40 -0400
Date: Thu, 18 Sep 2008 20:01:25 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Steven Noonan <steven@uplinklabs.net>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>, Ingo Molnar <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27
	(rc5, rc6, probably others)
Message-ID: <20080919030125.GG7408@tesla>
References: <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com> <43e72e890809181142n7738cd99g522e6688e68d11ce@mail.gmail.com> <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com> <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com> <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com> <20080918220102.GE7408@tesla> <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com> <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com> <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com> <f488382f0809181952g628ab5a4nd86f396a08f4d6c8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f488382f0809181952g628ab5a4nd86f396a08f4d6c8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 07:52:16PM -0700, Steven Noonan wrote:
> This IRQ debugging is lots of fun. My /var/log/messages jumped in size
> to 241MB. :)
> 
> My test case was a file transfer that basically copies 50MB from a
> remote machine's /dev/urandom and writes it to /dev/null locally. That
> should be a pretty nice large RX. And jeez, I'm seeing tremendous
> download speeds now and I have no idea what is different about my
> configuration. I'm getting up to 24 megabit per second transfer rates
> (actual), which is incredibly unusual for ath9k.
> 
> I wasn't able to reproduce the IRQ problems on -tip or Linus' current
> tree (both with the group rekeying fix applied, which may or may not
> be a good idea for reproducing the issue). Even tried doing
> rmmod/modprobe in fast succession multiple times. Couldn't get it to
> throw up.
> 
> I wonder... My rmmod/modprobe originally was used after the improper
> group rekeying before in order to get it back to normal. Perhaps the
> encryption has to go wonky before this IRQ issue surfaces? Another
> possibility is the earlier mentioned "ACPI: EC: GPE storm detected,
> disabling EC GPE". I don't know if it's related or not, but I haven't
> waited for it to show up before testing.
> 
> Oh well, if the IRQ problem resurfaces (or if I get a ridiculous
> latency tomorrow morning with irqpoll off), I'll try to get some
> useful data to help debug it.

Thanks for testing, and glad to see this is resolved.

  Luis
