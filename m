Return-Path: <linux-kernel-owner+w=401wt.eu-S934766AbXFFUQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766AbXFFUQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXFFUQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:16:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713AbXFFUQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:16:16 -0400
Date: Wed, 6 Jun 2007 13:16:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.22-rc4-mm1
Message-Id: <20070606131604.066c42fb.akpm@linux-foundation.org>
In-Reply-To: <4667018D.7020407@googlemail.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<4667018D.7020407@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 20:48:45 +0200 Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:

> Andrew Morton pisze:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
> > 
> 
> Kay, your patch gregkh-driver-block-device.patch breaks Fedora 7 initrd
> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/initrd.jpg
> 
> Please fix it ASAP, I can't test kernel...
> 

Yes, that looks just like what I was seeing on the yellowdog powerpc machine.

Is uses http://userweb.kernel.org/~akpm/config-g5.txt (plus `make oldconfig' of
course).

I'll revert it.
