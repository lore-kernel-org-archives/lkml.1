Return-Path: <linux-kernel-owner+w=401wt.eu-S1763560AbXGZGQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763560AbXGZGQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 02:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbXGZGQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 02:16:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56171 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbXGZGQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 02:16:38 -0400
Message-ID: <46A83AB5.4050201@zytor.com>
Date: Wed, 25 Jul 2007 23:09:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to
 platform devices - broke my serial console
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070723183839.GA5874@martell.zuzino.mipt.ru> <20070723190152.GA5755@martell.zuzino.mipt.ru> <20070723132431.42afbae8.akpm@linux-foundation.org> <20070723204045.GD5755@martell.zuzino.mipt.ru> <20070723210153.GA5753@martell.zuzino.mipt.ru> <20070723141137.171e4ac1.akpm@linux-foundation.org> <alpine.LFD.0.999.0707231415511.3607@woody.linux-foundation.org> <20070724175951.GC6019@stusta.de> <alpine.LFD.0.999.0707241113180.3607@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707241113180.3607@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> On Tue, 24 Jul 2007, Adrian Bunk wrote:
>> buffered_rmqueue() and prep_new_page() are static functions with only 
>> one caller each, and for the normal non-debug case it's a really nice 
>> optimization to have them inlined automatically.
> 
> I'm not at all sure I agree.
> 
> Inlining big functions doesn't actually tend to generally generate any 
> better code, so if gcc's logic is "single callsite - always inline", then 
> that logic is likely not right.
> 

Only up to a threshold, as far as I know.

	-hpa
