Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbZBFOzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbZBFOzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 09:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbZBFOzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 09:55:04 -0500
Received: from uhweb15152.united-hoster.com ([85.88.15.152]:56294 "EHLO
	uhweb15152.united-hoster.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757194AbZBFOzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 09:55:03 -0500
Message-ID: <498C4F2E.1070204@f-seidel.de>
Date: Fri, 06 Feb 2009 15:54:38 +0100
From: Frank Seidel <frank@f-seidel.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       herbert@gondor.apana.org.au, jarod@redhat.com
Subject: Re: [PATCH] crypto: add missing KERN_* constants to printks
References: <498C46DE.8040700@suse.de> <20090206145838.GA28197@x200.localdomain>
In-Reply-To: <20090206145838.GA28197@x200.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan schrieb:
> On Fri, Feb 06, 2009 at 03:19:10PM +0100, Frank Seidel wrote:
>> According to kerneljanitors todo list all printk calls (beginning
>> a new line) should have an according KERN_* constant.
> 
> Forget about kernel janitors todo list, fix a bug instead.

Sure, i am eager to get my hands dirty in the kernel ;-),
but i needed to start somewhere and everybody told me
that the janitors todo list would be good place to start.

>> Those are the missing pieces here for the crypto subsystem.
> 
> You're inserting KERN_WARNING everywhere, what for?

Because every new line should have KERN_* constant and
KERN_WARNING is default/doesn't change current printout
behaviour.

Thanks,
Frank
