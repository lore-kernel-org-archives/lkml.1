Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbZFBSNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbZFBSNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 14:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZFBSNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 14:13:37 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:53166 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbZFBSNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 14:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=qgE8HRNGrlIkUIHsl6OVieZmOc+1hfdlbLEDaRzPHM8thWglUS9UmYrtDjVYf1SICO
         ayriTfEznkzcy4HRIEyUQ3wWR3OHzu7V8KNeH/IVVgl1r8MjeQO3q1adIncYep8JczWJ
         F/CqKQRlHdmWePFRWITrdJwt4WAyzlv0amIsg=
MIME-Version: 1.0
In-Reply-To: <20090602162008.GH3914@think>
References: <4A0B62F7.5030802@goop.org> <20090525091527.GA7535@elte.hu>
	 <4A1C3805.7060404@goop.org> <20090528061702.GB6920@wotan.suse.de>
	 <20090530102330.GC16913@elte.hu> <20090602141802.GC3914@think>
	 <a36005b50906020749p22b89693k5c4ae171d18966a7@mail.gmail.com>
	 <20090602150339.GF3914@think>
	 <a36005b50906020822m33917c6fn5061af562b54c6c2@mail.gmail.com>
	 <20090602162008.GH3914@think>
Date: Tue, 2 Jun 2009 21:13:37 +0300
X-Google-Sender-Auth: caac9f48d55b4616
Message-ID: <84144f020906021113j12c3a8fbt40dd37ab780847ca@mail.gmail.com>
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native 
	kernels
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Chris Mason <chris.mason@oracle.com>, Ulrich Drepper <drepper@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

On Tue, Jun 2, 2009 at 8:03 AM, Chris Mason <chris.mason@oracle.com> wrote:
>>> The best place to fix xen is in the kernel.

On Tue, Jun 02, 2009 at 08:22:57AM -0700, Ulrich Drepper wrote:
>> No.  The best way to fix things is _on the way into the kernel_.

On Tue, Jun 2, 2009 at 7:20 PM, Chris Mason <chris.mason@oracle.com> wrote:
> It all depends on which parts are causing problems.  A 1% performance
> hit, under a CONFIG_ that can be disabled?  If maintainers are focusing
> on details like this for long term and active projects, we're doing
> something very wrong.

The fact that CONFIG_PARAVIRT can be disabled doesn't really help. As
a matter of fact, I'd argue that one of the primary reasons
CONFIG_SLUB regression is still there is because people can just
disable it and use CONFIG_SLAB instead.

So I think we have some evidence to suggest that people have less
incentive to fix things once something is merged to the kernel. And I
don't mean the authors of the code here but basically _everyone_
involved in kernel development. It usually takes effort from variety
of people to get everything ironed out because, lets face it, we can't
expect a handful of people to test out every configuration let alone
fix them.

                        Pekka
