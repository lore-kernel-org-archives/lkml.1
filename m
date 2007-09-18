Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbXIRIyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbXIRIyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 04:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbXIRIya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 04:54:30 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:32893 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbXIRIy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 04:54:29 -0400
Message-ID: <46EF922A.4030206@linux-kernel.at>
Date: Tue, 18 Sep 2007 10:54:02 +0200
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070615 Fedora/2.0.0.4-1.fc7 Thunderbird/2.0.0.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org,
       axp-list@redhat.com, Jay Estabrook <jay.estabrook@hp.com>,
       ac-admin@lists.anotherbloody.com, ink@jurassic.park.msu.ru
Subject: Re: 2.6.23 alpha unistd.h changes
References: <46EEE483.4020209@linux-kernel.at> <20070917212257.GA27980@stusta.de>
In-Reply-To: <20070917212257.GA27980@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-lkernAT-MailScanner-Information: Please contact the ISP for more information
X-lkernAT-MailScanner: Found to be clean
X-lkernAT-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-4.399, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -2.60)
X-MailScanner-From: oliver@linux-kernel.at
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2007 11:22 PM, Adrian Bunk wrote:
> On Mon, Sep 17, 2007 at 10:33:07PM +0200, Oliver Falk wrote:
>> At Alphacore we used to patch the kernel headers for a while now; We
>> added syscalls __NR_openat (447) until __NR_tee (466).
> 
> Why did your numbers differ from the numbers that were used in the 
> upstream kernel?

Afaik, our patch was done a while ago and nobody every submitted it
upstream - don't know why...

At AC, we follow RH/Fedora packages and there we had glibc-kernheaders -
where our patch originates. When the glibc/kernel packages changed and
glibc-kernheaders died, I patched the syscalls into kernel headers; Not
thinking that I better submit it upstream. :-(

> The Alpha maintainers (Cc's added) might now better what happened here.
> 
>> However, since 2.6.23 these syscall where added upstream, but with
>> different syscall numbers; What happens is the following:
>> ...
> 
> These syscalls were added in 2.6.22, not 2.6.23, and are therefore in 
> the officially released kernel since more than two months.

Yes, 2.6.22, I've just encountered the problem with 2.6.23...

> Changing a userspace ABI that has already been part of an officially 
> released kernel because someone patched other syscall numbers into his 
> private kernel doesn't sound like a good solution.

As I wrote in my previous mail, that's true, but if Debian folks haven't
recompiled glibc against the new headers we can change it without
breaking something...

-of
