Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbXFKP0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbXFKP0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 11:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbXFKPZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:25:49 -0400
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:39740 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbXFKPZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:25:48 -0400
X-Greylist: delayed 1608 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jun 2007 11:25:48 EDT
Date: Mon, 11 Jun 2007 07:58:59 -0700 (PDT)
From: alan <alan@clueserver.org>
X-X-Sender: alan@blackbox.fnordora.org
To: DervishD <lkml@dervishd.net>
cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
In-Reply-To: <20070611101319.GA14284@DervishD>
Message-ID: <Pine.LNX.4.64.0706110754280.12140@blackbox.fnordora.org>
References: <20070611101319.GA14284@DervishD>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007, DervishD wrote:

>    Hi all :)
>
>    I was wondering: is there any reason not to use ext2 on an USB
> pendrive? Really my question is not only about USB pendrives, but any
> device whose storage is flash based. Let's assume that the device has a
> good quality flash memory with wear leveling and the like...
>
>    Thanks a lot in advance :)

It depends...

Do you need to use OSes other than Linux?  FAT16/32 seems to be a pretty 
universal filesystem at this point.  You can mount ext2 on Windows, but it 
is a pain.  Not certain what it takes to mount it on OS X.

I have encountered flash drives that do not format well for anything other 
than FAT16, but they were old and small.  Hopefully that problem no longer 
exists with modern hardware.  I would format it then test the hell out of 
it before trusting it with important data.

-- 
"ANSI C says access to the padding fields of a struct is undefined.
ANSI C also says that struct assignment is a memcpy. Therefore struct
assignment in ANSI C is a violation of ANSI C..."
                                   - Alan Cox
