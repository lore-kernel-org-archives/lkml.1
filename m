Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYBRJ7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYBRJ7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 04:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYBRJ7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:59:18 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:59637 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbYBRJ7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:59:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=lDLN+vUxDHhN+4g1gJa9kTz4kNSVRrm9ueSsWSrHKh0NgjDNR9I5XUFB53UX12TRT/cAzC4wPyim2UH6okBquOrQc3XbMom37A1t9VT+RFWjZOlq6foZrP34FzbKiunPKEeEtHxB9+w1XM80bNwZIbikeaTqnQj9DR6TGTwgEDU=
Message-ID: <47B956EE.7020804@gmail.com>
Date: Mon, 18 Feb 2008 10:59:10 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Alexey Dobriyan <adobriyan@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tilman Schmidt <tilman@imap.cc>, Greg KH <gregkh@suse.de>
Subject: Re: 2.6.25-rc2: Reported regressions from 2.6.24
References: <200802172304.00322.rjw@sisk.pl> <47B9473D.20508@gmail.com> <b6fcc0a0802180143u65120b97wa87d59eb17f37ed2@mail.gmail.com> <20080218094939.GB31970@elte.hu>
In-Reply-To: <20080218094939.GB31970@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2008 10:49 AM, Ingo Molnar wrote:
> * Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
>> Why on earth do we have CONFIG_SYSFS_DEPRECATED at all if the only 
>> sane choice for someone who tests new kernels is to always turn it on?
> 
> seconded ...
> 
> it's insane how inconvenient certain storage systems are to use, and 
> people get turned away with NOATBUG. ITISABUG every time user-space 
> breaks or the user has to do _anything_ to get the box working as it 
> should.

No, user needn't to do anything. Just turn that default y option really to y 
(yes, you are right, the help text of this option is misleading...). It's like 
you turn off old acpi events option and scream that you acpi daemon doesn't work 
for instance. There are many instances of this behaviour in the kernel. And yes, 
many people don't need that option tuyrned on -- I think we need not-y testers 
too, but it might be my personal feeling.
