Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbZFKSYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbZFKSYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZFKSYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:24:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4823 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZFKSYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:24:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=aJYPsP75dHUXpq7t1+UlPefl0PsqKpGYzaN+hHABmyRFJOgGDGxS58/8gLD4NzXKy
	taaur5MKGk5WEgzpj6i2g==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
References: <20090611160329.GA3366@elte.hu>
	 <20090611161714.GA5008@infradead.org>
	 <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain>
	 <20090611165226.GV8633@ZenIV.linux.org.uk>
	 <1244739378.6691.540.camel@laptop>
	 <20090611170015.GA3651@infradead.org>
	 <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain>
Date: Thu, 11 Jun 2009 11:24:20 -0700
Message-ID: <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com>
Subject: Re: [GIT PULL] Performance Counters for Linux
From: Martin Bligh <mbligh@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> So what point is there in keeping it in-tree except making life hell for
>> packagers?
>
> Give it up. Packagers can trivially generate their own sub-packages. They
> do it all the time. They already do it for the user-mode header files,
> extracted from the kernel - something you've worked on yourself.
>
> So your point is clearly bogus, and dishonest.
>
> You haven't actually looked the real problem in the eye, and acknowledged
> the disaster that is oprofile. Let's give a _new_ approach a chance, and
> see if we can avoid the mistakes of yesteryear this time.

We actually ended up coming to the same conclusion as you for some of the
internal tools we use that are tightly tied to the kernel. There is one hitch,
which is that if you boot between different kernel versions, you need multiple
userspace versions of the tools, so you may need to put them in
/lib/modules/<kernel-version> or something equivalent, not one fixed place.

M.
