Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZGARz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZGARz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 13:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZGARzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 13:55:16 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:63106 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZGARzP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 13:55:15 -0400
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901A13822@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901A13822@mi8nycmail19.Mi8.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 1 Jul 2009 19:55:02 +0200
Message-ID: <ac3eb2510907011055r5d5f06c1k754e52ebae88efab@mail.gmail.com>
Subject: Re: Problem with /proc/iomem on ARM
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 19:32, H Hartley
Sweeten<hartleys@visionengravers.com> wrote:
> I just noticed a problem with /proc/iomem on my ARM system
> that I think was introduced by your patch:
>
> commit 1d559e29138834bbcdf34ac072232bf543bfc4e0
> Author: Kay Sievers <kay.sievers@vrfy.org>
> Date:   Tue Jan 6 10:44:43 2009 -0800
>
>    arm: struct device - replace bus_id with dev_name(), dev_set_name()
>
>    Cc: Russell King <rmk@arm.linux.org.uk>
>    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
>    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

> This was seen with kernel 2.6.30.  I havn't looked at /proc/iomem for
> a while so I'm not sure when this first started.

Are you sure, 8a577ffc75d9194fe8cdb7479236f2081c26ca1f isn't in your tree?

After all, it seems like this should be fixed in arm somewhere, not to
copy and store internal driver core pointers, but use the device
itself to retrieve the values.

Thanks,
Kay
