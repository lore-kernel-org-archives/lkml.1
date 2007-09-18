Return-Path: <linux-kernel-owner+w=401wt.eu-S1759587AbXIRPpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587AbXIRPpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756105AbXIRPp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:45:28 -0400
Received: from pils.linux-kernel.at ([213.129.242.82]:5605 "EHLO
	mail.linux-kernel.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbXIRPp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:45:27 -0400
Message-ID: <46EFF244.5070202@linux-kernel.at>
Date: Tue, 18 Sep 2007 17:44:04 +0200
From: Oliver Falk <oliver@linux-kernel.at>
Organization: Linux kernel Austria
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070615 Fedora/2.0.0.4-1.fc7 Thunderbird/2.0.0.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org, axp-list@redhat.com,
       Jay Estabrook <jay.estabrook@hp.com>, ac-admin@lists.anotherbloody.com
Subject: Re: 2.6.23 alpha unistd.h changes
References: <46EEE483.4020209@linux-kernel.at> <20070917214107.GB27980@stusta.de> <46EF90A3.2050109@linux-kernel.at> <20070918140738.GD27980@stusta.de>
In-Reply-To: <20070918140738.GD27980@stusta.de>
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

On 09/18/2007 04:07 PM, Adrian Bunk wrote:
> On Tue, Sep 18, 2007 at 10:47:31AM +0200, Oliver Falk wrote:
>> On 09/17/2007 11:41 PM, Adrian Bunk wrote:
>>> On Mon, Sep 17, 2007 at 10:33:07PM +0200, Oliver Falk wrote:
>>>> Hi!
>>> Hi Oliver!
>>>
>>>> ...
>>>> As these additions are quite new to upstream kernel, but at Alphacore we
>>>> have patched it since a while now (I don't know about other Alpha ports;
>>>> Debian folks may speak up now!), I would suggest to use the same
>>>> 'ordering' of the syscalls upstream and add the new syscalls that we had
>>>> not in place, but are now upstream to the end of our 'old' list.
>>>> ...
>>> I just checked:
>>>
>>> It seems Debian didn't patch them into the kernel at all, and since two 
>>> months Debian unstable ships kernel 2.6.22 with the upstream syscall 
>>> numbers.
>> That's possible a problem. Right. Someone with contacts to Debian here?
>> If Debian hasn't rebuilt glibc against the new headers, we could change
>> it without problems.
>> ...
> 
> According to the Debian auto-builder database [1], the Alpha glibc 
> package in Debian unstable has been rebuilt 8 times since the 2.6.22 
> kernel packages entered Debian unstable.
> 
> And it's not only Debian, at least Gentoo also offers an Alpha port.

Well. As I said. I'll step back and let it be as it is. Debian was to
fast. :-)

-of
