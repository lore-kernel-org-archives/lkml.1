Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbZFKWS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbZFKWS7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZFKWSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:18:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:24421 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbZFKWSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:18:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=gDbn+FFehBirLd8L0Uxm2DUNHDD8IUuthKbHJ47tDr6b7oNqv57AHXW6Oec+7uXafR
         Was89O1lHll4a0iOYzNomGtQT727ryAKRYt/j1fW2Su87sxv6noqAW9e/zxO+ZR/INyP
         UlpZ7d4W9KvEL7GwwwGuc6vetvQIA12lclCB0=
Message-ID: <4A3182C6.803@gmail.com>
Date: Fri, 12 Jun 2009 00:18:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.4 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Marcel Holtmann <marcel@holtmann.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Bligh <mbligh@google.com>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
References: <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org> <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <33307c790906111124m17e57332oc38c89fa70e39231@mail.gmail.com> <alpine.LFD.2.01.0906111127520.3573@localhost.localdomain> <20090611202341.GA23590@elte.hu> <1244753357.27363.82.camel@violet> <20090611210810.GA9317@uranus.ravnborg.org> <1244755036.27363.93.camel@violet> <20090611212635.GA9446@uranus.ravnborg.org>
In-Reply-To: <20090611212635.GA9446@uranus.ravnborg.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 06/11/2009 11:26 PM, Sam Ravnborg wrote:
> On Thu, Jun 11, 2009 at 11:17:16PM +0200, Marcel Holtmann wrote:
>> I personally would expect a perf.git on kernel.org for the userspace
>> tools for it. Like we have udev.git there, iproute2.git and others.
>>
>> Seems to be working perfectly fine (except of course oprofile) and makes
>> packaging and security updates a lot easier.
> There is nothing preventing us from adding support for rpm and source rpms.
> So you just grab the relevant tre and issue a few cammnds and you have your
> packages.

Bah, having 40M .src.rpm for a 5k binary package?

Maybe I'm missing something, how exactly do you conceive the packaging?
Or do you expect packagers to download a kernel package, untar it, get
tools/ dir, tar it and package? I hope not :).

And how would we cope with a different release cycle of the userspace
tool? If one rewrites a part totally independent on the kernel, do they
need to wait for the next kernel release? Or just merge it at any time
and packagers pick it up?

> And for security fixes we have the stable kernels.

So packagers will stick with the latest stable, right? With backporting
of (only stable) new fancy features from current git until next kernel
release.

