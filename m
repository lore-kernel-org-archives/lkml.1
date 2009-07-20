Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734AbZGTVIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734AbZGTVIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 17:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZGTVIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 17:08:04 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:51016 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZGTVID convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 17:08:03 -0400
MIME-Version: 1.0
In-Reply-To: <20090720205726.GD4295@vespa.holoscopio.com>
References: <1246766879-5784-1-git-send-email-cascardo@holoscopio.com> 
	<20090720131959.3b157627.akpm@linux-foundation.org> <ac3eb2510907201332i25ea109t981425451eafd4e1@mail.gmail.com> 
	<20090720205726.GD4295@vespa.holoscopio.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 20 Jul 2009 23:07:47 +0200
Message-ID: <ac3eb2510907201407v591c23bdxc67c895832b783aa@mail.gmail.com>
Subject: Re: [PATCH] RTC: mark if rtc-cmos drivers were successfully 
	registered.
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       bjorn.helgaas@hp.com, Alessandro Zummo <a.zummo@towertech.it>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 22:57, Thadeu Lima de Souza
Cascardo<cascardo@holoscopio.com> wrote:
> On Mon, Jul 20, 2009 at 10:32:06PM +0200, Kay Sievers wrote:
>> On Mon, Jul 20, 2009 at 22:19, Andrew Morton<akpm@linux-foundation.org> wrote:

>> > I believe Kay was planning on making the driver core more robust, so
>> > that crash shouldn't be happening any more.  Kay, can you please confirm
>> > that thsi got fixed?
>>
>> This is supposed to fix it:
>>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5c8563d773c0e9f0ac2a552e84806decd98ce732

> Yes, but instead of an oops, we get a warning when the driver could just
> behave properly. That's the intention of this patch: do not warn the
> user when there's nothing to warn about, as long as the driver behaves
> itself.

Sure, it was not supposed to fix the rtc issue properly, it's just to
make it not oops. :)

Thanks,
Kay
