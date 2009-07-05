Return-Path: <linux-kernel-owner+w=401wt.eu-S1755724AbZGESMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724AbZGESMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 14:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbZGESM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 14:12:29 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:59826 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZGESM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 14:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=svZnPc4LrQRa0lJys4UEC+5npa5/UBJw7PlI1aBXHiivVoTWfdY9HHU5QT7U7i3xsW
         apUhf+Qu1Bv2XR1fj6nTQN8JydHbxrLJ6uXgzCt7aDVoX9UTcV+7MVV1cR4KBjyro/Wd
         /Nl78J2UQkoRM7TuPQQzwltxWusI+SHUA5zU4=
Date: Sun, 5 Jul 2009 22:12:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic -- reduce disable_apic usage
Message-ID: <20090705181225.GH4791@lenovo>
References: <20090705162044.GC4791@lenovo> <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org> <20090705165947.GD4791@lenovo> <20090705171251.GE4791@lenovo> <20090705171739.GF4791@lenovo> <alpine.LFD.2.00.0907051846280.13862@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907051846280.13862@eddie.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Sun, Jul 05, 2009 at 06:47:53PM +0100]
| On Sun, 5 Jul 2009, Cyrill Gorcunov wrote:
| 
| > To be precise -- for discrete apic we set this bit manually.
| 
|  Ah, OK then.  That didn't use to be the case.
| 
|   Maciej
| 

Hmm.. Just reread code. The user are to pass "lapic" option
for this case. At least I didn't find explicit assignment
for cpu_has_apic bit even if MP table has been read successfully.

But I didn't change anything in detect_init_APIC so this case
was here before me :)

	-- Cyrill
