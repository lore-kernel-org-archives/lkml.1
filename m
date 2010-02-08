Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab0BHWYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:24:05 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:37504 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751324Ab0BHWYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:24:01 -0500
Date: Tue, 9 Feb 2010 01:23:59 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Richard Purdie <rpurdie@linux.intel.com>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds-gpio: Fix default state handling on OF platforms
Message-ID: <20100208222359.GA1870@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20100205205437.GA4733@oksana.dev.rtsoft.ru>
 <20100208130455.8cb90ff1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100208130455.8cb90ff1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 01:04:55PM -0800, Andrew Morton wrote:
> On Fri, 5 Feb 2010 23:54:37 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > The driver wrongly sets default state for LEDs that don't specify
> > default-state property.
[...]
> Does this actually happen in any 2.6.33 driver code?

Well, the code that I fixed constructs Linux structures out of
OpenFirmware device tree. OF tree is somewhat similar to ACPI or
DMI tables in x86 world. So, in general, OF isn't kernel version
dependant.

(We have an in-tree depot of device trees for reference/devel boards
in arch/powerpc/boot/dts/, but this is surely not a conclusive
list of device trees in the wild.)

> If so, we might
> want to merge this into 2.6.33.  And perhaps earlier kernels.  Or not. 
> There's no way for me to tell :(

Since the fix is trivial, I'd say 2.6.33. But the issue isn't major,
so no big deal if it won't make it.

Thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
