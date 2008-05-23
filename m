Return-Path: <linux-kernel-owner+w=401wt.eu-S1763199AbYEWGie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763199AbYEWGie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 02:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753772AbYEWGi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 02:38:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:56128 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbYEWGiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 02:38:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fSIdX6wFGtK9ywidHeOe45iYf+j0NjnxfPMHleHQ2Ck1THoZwKa4QkZuRhsmmZuO93ieMbtK63XoiU9Tzrs67MX7goELoEdCyRyfg56ZVTz7EQ1c7pxcwpbQb14CWxg5b+LU21v/6SWHTMKoCyhD69nRlzGpT+tpSNE3HjiCqUE=
Message-ID: <86802c440805222338w3c8e946eree2d090ce12609e@mail.gmail.com>
Date: Thu, 22 May 2008 23:38:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: [PATCH] x86: early dump pci conf space v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080523053822.GA28835@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805210012.35939.yhlu.kernel@gmail.com>
	 <200805221435.11734.yhlu.kernel@gmail.com>
	 <20080523053822.GA28835@colo.lackof.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 10:38 PM, Grant Grundler
<grundler@parisc-linux.org> wrote:
> On Thu, May 22, 2008 at 02:35:11PM -0700, Yinghai Lu wrote:
>>
>> so we can printout pci config before kernel touch it
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> Yinghai,
> No offense, but my first thought was this is debug code that should be
> maintained outside the kernel.org tree. It will rarely get used.
> Just want people to think about this before saying "great, add it!"
>
> (And this isn't a stab at Jesse since I think he's doing a better
> job than I could. I saw his previous reply to this mail.)
>
> Having debugged lots of PCI resource and config issues, I understand
> why this is useful and do NOT object to it being included in the tree.

could print out the setting from buggy BIOS, or first kernel.
and don't need the reporter apply debug patch again...

>
> The boot option also needs to be added to Documentation/ .
> At least if you want people to use it. :)
> Perhaps Jesse can suggest a preferred location.

we could add it.
..
>
> Please call this "pci_early_dump" (I prefer with underscores but don't care).
> Don't want it confused with kernel dumps (LKCD) or any other
> general debugging tools.

so you want pci_early_dump instead of pci=earlydump?
or pci=early_dump?

YH
