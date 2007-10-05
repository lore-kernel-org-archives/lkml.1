Return-Path: <linux-kernel-owner+w=401wt.eu-S1764767AbXJEX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764767AbXJEX3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761393AbXJEX3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:29:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46454 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761334AbXJEX3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:29:11 -0400
Message-ID: <4706C8BD.7080906@zytor.com>
Date: Fri, 05 Oct 2007 16:29:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [code] Unlimited partitions, a try
References: <Pine.LNX.4.64.0710051347470.13406@fbirervta.pbzchgretzou.qr>	<4706B6A8.2060800@zytor.com> <20071006002919.0b32c8b9@the-village.bc.nu>
In-Reply-To: <20071006002919.0b32c8b9@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Fri, 05 Oct 2007 15:11:52 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> Jan Engelhardt wrote:
>>> 15 partitions (at least for sd_mod devices) are too few.
>> Now when we have 20-bit minors, can't we simply recycle some of the 
>> higher bits for additional partitions, across the board?  63 partitions 
>> seem to have been sufficient; at least I haven't heard anyone complain 
>> about that for 15 years.
> 
> This was proposed ages ago. Al Viro vetoed sparse minors and it has been
> stuck this way ever since. If you have > 15 partitions use device mapper
> for it. I'd prefer it fixed but its arguable that device mapper is the
> right way to punt all our partitioning to userspace

Sure.  However, that takes having that bit of userspace in even the most 
trivial configurations, and not just on bootup, but continuously.

	-hpa
