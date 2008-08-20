Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbYHTVhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbYHTVhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:37:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752409AbYHTVhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:37:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752048AbYHTVhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:37:05 -0400
Date: Wed, 20 Aug 2008 14:36:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Duncan Sands <duncan.sands@free.fr>, linux-usb@vger.kernel.org
Subject: Re: linux-next: Tree for August 20
Message-Id: <20080820143656.88a03e1f.akpm@linux-foundation.org>
In-Reply-To: <20080820190649.a63e3e00.sfr@canb.auug.org.au>
References: <20080820190649.a63e3e00.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Aug 2008 19:06:49 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

drivers/usb/atm/usbatm.c: In function 'usbatm_extract_one_cell':
drivers/usb/atm/usbatm.c:347: error: implicit declaration of function 'warn'

due to

#define UDSL_ASSERT(x)  do { if (!(x)) warn("failed assertion '%s' at line %d", __stringify(x), __LINE__); } while(0)

which was quite clever really - neither drivers/usb/atm/usbatm.c nor
drivers/usb/atm/usbatm.h was changed.

config: http://userweb.kernel.org/~akpm/config-akpm2.txt  (it's x86_64)
