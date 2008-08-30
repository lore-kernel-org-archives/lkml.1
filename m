Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYH3AL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYH3AL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 20:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYH3ALs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 20:11:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:35059 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbYH3ALr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 20:11:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fsaV7KHJMhTbd1D8z7Hkzf0lnz3rWY7p5jStXGsyjAykk46QE0wDtCChaIi54KhQvW
         PKZfAO3Oum/w1yi/YI9lDmlBJjrimj2mjl8T4WTD6eqSAE1tX+u4PA9KABSIqCnlfcTx
         H2kIulfuAif6Q9VuNbSjUj80BNQtMkRMFWT1c=
Message-ID: <86802c440808291711t32d3e76dsf804856b0a8f4939@mail.gmail.com>
Date: Fri, 29 Aug 2008 17:11:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.27-rc5: System boot regression caused by commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Tejun Heo" <htejun@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Kernel Testers" <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0808281555230.3300@nehalem.linux-foundation.org>
	 <200808292157.24179.rjw@sisk.pl>
	 <86802c440808291413t4f31993fmba59a65aefd906ca@mail.gmail.com>
	 <200808300031.16708.rjw@sisk.pl>
	 <86802c440808291624t2bd0229w2da36dfc6c794b18@mail.gmail.com>
	 <alpine.LFD.1.10.0808291704070.3300@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 5:08 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Fri, 29 Aug 2008, Yinghai Lu wrote:
>> >
>> > http://www.sisk.pl/kernel/debug/mainline/2.6.27-rc5/broken.log
>>
>> pci 0000:00:00.0: BAR has MMCONFIG at e0000000-ffffffff
>
> And that seems utter crap to begin with.
>
>        PCI: Using MMCONFIG at e0000000 - efffffff
>
> Where did it get that bogus "ffffffff" end address?

the BAR is from pci_read_bases..., so that chipset is broken...
they are even supposed to to hide that BAR to os.

YH
