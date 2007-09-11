Return-Path: <linux-kernel-owner+w=401wt.eu-S1755619AbXIKVhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619AbXIKVhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbXIKVhq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:37:46 -0400
Received: from ns.suse.de ([195.135.220.2]:57505 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526AbXIKVhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:37:46 -0400
From: Andi Kleen <ak@suse.de>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: x86 merge - a little feedback
Date: Tue, 11 Sep 2007 22:34:23 +0100
User-Agent: KMail/1.9.1
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070911201219.GA9674@uranus.ravnborg.org> <200709112138.11247.ak@suse.de> <20070911211422.GU3563@stusta.de>
In-Reply-To: <20070911211422.GU3563@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709112234.24155.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>
> People do not expect code under arch/i386/ to be used by code under
> arch/x86_64/ and vice versa.
>
> That regularly results in people sending patches that don't compile on
> the other architecture.
>
> With one architecture it's much more obvious that the code is shared.

Will that cause people to compile test both? I have my doubts that 
will really work.

e.g. a similar example would be CONFIG_MMU=n. The code 
is mostly shared and in the same directories, but people still
break the MMUless architectures all the time. 

I don't expect this to be different with 32bit/64bit.

-Andi
