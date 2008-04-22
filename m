Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbYDVMtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbYDVMtP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 08:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYDVMtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 08:49:00 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:31362 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396AbYDVMs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 08:48:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ppSWG8s5z3+epkAJX0m7wm9o+YTm03sVLc45bRJhyzXhvE4QgiDKsTJ0Q4iFkR+4IR0WsP++XPhbpTnwZ5A24wuP6t0D0LED3a4vrJVKkDhOGJPhz2Ss60ywUObtmGXHKJwTreBaYP6aDfOiZZr6vxVP4H5t3BhekgiHN7jiQD4=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: David Chinner <dgc@sgi.com>
Subject: Re: x86: 4kstacks default
Date: Tue, 22 Apr 2008 14:48:09 +0200
User-Agent: KMail/1.8.2
Cc: Eric Sandeen <sandeen@sandeen.net>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Shawn Bohrer <shawn.bohrer@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20080419142329.GA5339@elte.hu> <200804212151.02241.vda.linux@googlemail.com> <20080422012819.GT108924158@sgi.com>
In-Reply-To: <20080422012819.GT108924158@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804221448.09828.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 03:28, David Chinner wrote:
> We've already chopped off the low hanging fruit, added noinline to
> every function definition to prevent compiler heuristics from
> blowing out stack usage by 25% and reduced use of temporary
> variables as much as possible. There's very little fat left to trim,
> and still we can't reliably fit in 4k stacks.

At yet, I got four screenfuls of

fs/xfs/XXXXX.c: warning: unused parameter 'foo'

when I added -Wunused_parameter to Makefile.
Clearly there is some room for improvement.

> Patches are welcome - I'd be over the moon if any of the known 4k
> stack advocates sent a stack reduction patch for XFS, but it seems
> that actually trying to fix the problems is much harder than
> resending a one line patch every few months....

Sent a few.
I would like to ask you to ACK/NAK every individual patch
in some reasonable period of time, say, 1-3 days. If you NAK a patch,
please let me know what is wrong with it.

I am not eager at all to experience a repeat of aic7xxx
patch saga, when I was not getting any meaningful reply
for months.

Best regards, Denys.
--
vda
