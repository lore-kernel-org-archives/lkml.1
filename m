Return-Path: <linux-kernel-owner+w=401wt.eu-S1752481AbXJVQKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbXJVQKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 12:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbXJVQKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 12:10:31 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:40301 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750956AbXJVQKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 12:10:30 -0400
Message-ID: <471CCB77.3040004@crispincowan.com>
Date: Mon, 22 Oct 2007 09:10:31 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Thomas Fricaccia <thomas_fricacci@yahoo.com>, linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: LSM conversion to static interface
References: <200710220224.l9M2Og5t020815@sapphire.spiritone.com> <20071022110718.3f781108@the-village.bc.nu>
In-Reply-To: <20071022110718.3f781108@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sun, 21 Oct 2007 19:24:42 -0700
> "Thomas Fricaccia" <thomas_fricacci@yahoo.com> wrote
>> Yes, I think Crispin has succinctly summed it up:  irrevocably closing
>> the LSM prevents commercial customers from using security modules other
>> than that provided by their Linux distributor.  As Sarbanes-Oxley and
>> other regulatory laws require these customers to use "standard
>> kernels", the result is a rather dreary form of vendor lock-in, where the
>> security framework is coupled to the distribution.
>>     
> Crispin at least is providing genuine discussion points. Sarbox has
> nothing to say on "using vendor linux kernels".
>   
I agree that SarBox is not really the issue here. Partially related is
enterprise rules about what kernels one is allowed to load. More
generally, this change forces users who want to use a different LSM than
their vendor provides to recompile their kernel, where they did not have
to recompile before. It forces LSM module developers who want to modify
their LSM to reboot, where they didn't necessarily have to reboot before.

That is not a catastrophe, it is just tedious. It does not kill baby
seals, and it does not make Linux utterly useless. OTOH, I think it is
strictly negative: it takes away user choice in 2 dimensions, and adds
zero value. So apply it if you must to bake the kernel developer's lives
easier, but it really is a net loss in Linux kernel capability.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin/
	       Itanium. Vista. GPLv3. Complexity at work

