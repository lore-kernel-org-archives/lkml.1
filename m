Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbYA0VwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbYA0VwW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 16:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYA0VwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 16:52:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:62849 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbYA0VwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 16:52:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=lgxSOUoXOX7KaFcRyI91VQbywrw/nqUOD5gOYfOJAK4ivQxBPtFQ/0ttVQc9sKwViZH9OBiyKFskETLF6PrYtMFLrbG72OKbmhXieZ5HveXV7sJLzWsnyENDTEpYAGYL1eqOU/Y3jsGNL2fxSAOJhKXXuHgPAcPY7zSqMB72jD0=
Date: Sun, 27 Jan 2008 22:51:55 +0100 (CET)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Steven Rostedt <rostedt@goodmis.org>
cc: Valdis.Kletnieks@vt.edu, caglar@pardus.org.tr,
       LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc7-rt2
In-Reply-To: <Pine.LNX.4.58.0801210738140.13659@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.64.0801272230270.8920@frodo.shire>
References: <1200336080.318.8.camel@localhost.localdomain>
 <200801150237.44029.caglar@pardus.org.tr> <24149.1200455417@turing-police.cc.vt.edu>
            <Pine.LNX.4.58.0801152302580.10869@gandalf.stny.rr.com>
 <31516.1200464589@turing-police.cc.vt.edu> <Pine.LNX.4.58.0801160904200.9544@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0801161112140.15998@gandalf.stny.rr.com>
 <Pine.LNX.4.64.0801211223210.11032@frodo.shire>
 <Pine.LNX.4.58.0801210738140.13659@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 21 Jan 2008, Steven Rostedt wrote:

>
> On Mon, 21 Jan 2008, Esben Nielsen wrote:
>>
>> Please, tell what in the license forbids me to make a global replacement
>> EXPORT_SYMBOL_GPL -> EXPORT_SYMBOL and distribute the result?
>
> If you want to distribute that code, the authors of that said code
> may be able to challenge you in saying that you are enabling a means to
> circumvent a way around the license, and hold you liable. Remember, all it
> takes is one country with the laws that will grant this complaint.
>
>>
>> For me, on the other hand, it is against the spirit of free software to
>> actively make a block for people to do what ever they want with the code
>> when they are only doing it to themselves. That includes loading non-GPL
>> software into the kernel. The only thing they  are not allowed to do is to
>> distribute it and in that way "hurt" other people.
>
> Honestly, I don't care which export it is. The thing is that I derived
> that code from someone else. I did not look up the original author of the
> code to find out which export they would like it to be. I may be able to
> argue that since it was under a LGPL and not a GPL license, I may very
> well be able to export it that way.
>
> I'm taking the safe way out. By exporting it as EXPORT_SYMBOL_GPL, I am
> safe either way. By exporting it as EXPORT_SYMBOL without first hearing
> from the original author (and getting that in writing), or hearing it from
> a lawyer, I may be putting myself at risk.
>
> Feel free to creating a version of this code and
> s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/ and distribute it. I wont come after
> you for that, but at least I know those that would, will go after you and
> not me.
>
> Call me a chicken, I don't care, but I'm just not going to put myself nor
> my company I work for, at risk over this issue.
>

First off, sorry for sounding so harsh and sorry for taking this 
discussion onto you. It is quite off-topic in this context. It was just 
a rant about the misconception that adding/removing _GPL to 
EXPORT_SYMBOL can make non-GPL modules more or less legal. Is is a 
_political_ issue, not a legal one.

Esben

> -- Steve
>
