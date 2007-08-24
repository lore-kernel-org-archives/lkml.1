Return-Path: <linux-kernel-owner+w=401wt.eu-S1764670AbXHXSFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764670AbXHXSFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932580AbXHXSFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:05:22 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3244 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391AbXHXSFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:05:20 -0400
Message-ID: <46CF1DDE.7070302@xs4all.nl>
Date: Fri, 24 Aug 2007 20:05:18 +0200
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Benoit Boissinot <bboissin@gmail.com>
Subject: Re: possible BUG while doing gpg --gen-key
References: <46CF079C.7010304@xs4all.nl> <40f323d00708241057k6549f22fl6abf802f14c03e44@mail.gmail.com>
In-Reply-To: <40f323d00708241057k6549f22fl6abf802f14c03e44@mail.gmail.com>
X-Enigmail-Version: 0.95.3
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit Boissinot wrote:
> On 8/24/07, Udo van den Heuvel <udovdh@xs4all.nl> wrote:
>> While doing gpg --gen-key I can reproduce quite well some sort of
>> crash/bug/etc:
>> # gpg --gen-key
> 
> [snip]
> 
> iirg gpg-keygen uses a lot of cpu time during that phase, you probably
> should verify your ram and cpu. This kind of problem is often due to
> faulty hardware.

The box runs stable for days on end.
Only when running gpg --gen-key I get this issue.
Other gpg operations, run by a user, are without issue.
There is 512MB of RAM and the hardware is `refreshed` regularly when an
interesting VIA board comes out. Case stays closed otherwise. I am ESD
certified. (or how to put that in the english language)
memtest86 shows no problems. Kernel compiles etc run without issue.
F7 upgraded installation. Updated regularly. gnupg rpm is Red Hat-stock.
 My own compiles of gnupg show the same error.

So what is next?
