Return-Path: <linux-kernel-owner+w=401wt.eu-S1763222AbXIXTSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763222AbXIXTSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759442AbXIXTSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:18:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:33752 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759414AbXIXTSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:18:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=TqrJEYh5KkHG7YZsqGNHk/pZCqFq/bfHrA3Kfjad8cCo7c8bvfbVmUv3A24QbpLib7zAEp29tzsXJUbOrJWigw0q2yjVlDqGFS/z+C81dWHjjTy0HrI59g8qUy8BoHhAoCHGr1/KR48dEGxmV1Cfp0kEyv5hLuXpGRu/MDh7GNU=
Message-ID: <46F80D85.9020209@gmail.com>
Date: Mon, 24 Sep 2007 21:18:29 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] 2.6.23-rc7-mm1
References: <Pine.LNX.4.44L0.0709241504590.5501-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709241504590.5501-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2007 09:06 PM, Alan Stern wrote:
> On Mon, 24 Sep 2007, Jiri Slaby wrote:
> 
>> On 09/24/2007 04:41 PM, Alan Stern wrote:
>>> On Mon, 24 Sep 2007, Jiri Slaby wrote:
>>>
>>>> On 09/24/2007 11:17 AM, Andrew Morton wrote:
>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
>>>> Fine, but on some boots (I noticed this on rc6-mm1 too, but not before):
>>>> 0000:00:1a.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
>>>> 0000:00:1d.7 EHCI: BIOS handoff failed (BIOS bug ?) 01010001
>>> Any changes in your BIOS setup?
>> unlikely, but still possible -- I've made some changes in BIOS recently when I
>> looking backwards. Which concrete changes would turn it in such behaviour?
> 
> USB Legacy Support is about the only change which springs to mind.  But 
> who knows...  A buggy BIOS could do almost anything.

Hmm, I have usb legacy keyboard switched on because of grub and bios to allow me
 typing.

I booted 23-rc7 4 times, and the latest -mm 3 times just now and can't reproduce
it, I just wonder by what is this conditioned.

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
