Return-Path: <linux-kernel-owner+w=401wt.eu-S1764678AbYD0XkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764678AbYD0XkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760051AbYD0Xj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:39:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56852 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbYD0Xjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:39:55 -0400
Message-ID: <48150EB0.2000301@zytor.com>
Date: Sun, 27 Apr 2008 16:39:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: David Miller <davem@davemloft.net>, James.Bottomley@HansenPartnership.com,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <20080427214837.GA11631@elte.hu>	<1209335660.3801.79.camel@localhost.localdomain>	<4815009C.2010809@garzik.org> <20080427.154620.177583216.davem@davemloft.net> <48150392.6040508@zytor.com> <48150DA3.5020606@garzik.org>
In-Reply-To: <48150DA3.5020606@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> H. Peter Anvin wrote:
>> Arguably, the right thing is to not even have ioremap() anymore, just 
>> ioremap_{cache,nocache,wc} and consider any unconverted ioremap() as a 
>> flag to audit that particular piece of code.
> 
> Seems like a sane plan...  last handful might be tough, though.

No doubt, although the vast majority of all call sites can probably be 
trivially changed to ioremap_nocache().

	-hpa
