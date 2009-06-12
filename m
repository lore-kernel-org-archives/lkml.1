Return-Path: <linux-kernel-owner+w=401wt.eu-S933616AbZFLJ5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616AbZFLJ5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764173AbZFLJ4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:56:33 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:59509 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764169AbZFLJ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:56:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=NuDVgny5vrHIPN3c1KfEj3sLTpvoF/5MiLqWzcESKY2EUgxkzJ2T1TeoAuKEy0KfPK
         evjPTWQL8fJXXFN0GaKn9xcY1JXu5uT4hPaYNcb8itW4TwC+kNIjJoFSkMV6ShN3EkH6
         BE+ya9CDZSPoBdqFfUYdC1HAqQaIxmiLfUQ/k=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090611160329.GA3366@elte.hu>
References: <20090611160329.GA3366@elte.hu>
Date: Fri, 12 Jun 2009 11:56:33 +0200
Message-ID: <7c86c4470906120256m545363d4h85a3e84a88291ac7@mail.gmail.com>
Subject: Re: [GIT PULL] Performance Counters for Linux
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 11, 2009 at 6:03 PM, Ingo Molnar <mingo@elte.hu> wrote:

> The counter concept got objected to in past discussions on lkml, by
> DaveM and by Stephane Eranian (i've Cc:-ed them) - so this code was
> not eligible for linux-next testing - nevertheless we gave it good
> testing on PowerPC and x86 and i've done a wide cross-build test as
> well to try to make sure it breaks no other architecture.

I don't think you can quote me saying "I object to this code". I posted
a detailed review of the API and implementation on X86 outlining lots
of issues. Some got fixed, but many others are left unresolved at this
point. And I will post some more shortly.

I don't think that because this code is coming from you, it should be
allowed to short-circuit the established release process. You have
to respond to questions, fix issues like everybody else and if that
slows down the integration you cannot blame the reviewers for it.
