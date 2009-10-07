Return-Path: <linux-kernel-owner+w=401wt.eu-S1759995AbZJGUHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759995AbZJGUHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759976AbZJGUHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:07:07 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:47815 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759974AbZJGUHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:07:05 -0400
MIME-Version: 1.0
In-Reply-To: <9b2b86520910071246r393f2afvacaa4d8f544508a8@mail.gmail.com>
References: <20091007175403.GA335@trillian.comsick.at> <9b2b86520910071246r393f2afvacaa4d8f544508a8@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 7 Oct 2009 22:06:13 +0200
Message-ID: <ac3eb2510910071306r4ad6dc9btb7503bc3ab0ec815@mail.gmail.com>
Subject: Re: [BUG] No ttyS0 - Strange udev 8250_pnp interaction
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: Michael Guntsche <mike@it-loops.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-hotplug <linux-hotplug@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 7, 2009 at 21:46, Alan Jenkins
<sourcejedi.lkml@googlemail.com> wrote:
> Udev would have avoided the race prior to
>
> 82c785e "udevd: remove check for dev_t, DEVPATH_OLD takes care of that"
>
> (the "check" removed here used to serialize events based on the device
> major:minor number).
>
> So - udev probably needs to add the check back.

What are the two devices with the same major/minor but a different DEVPATH?

> It might also be the case that future kernels could set DEVPATH_OLD as
> suggested.  I don't know the gory details of 8250_pnp though.

The DEVPATH_OLD is only added when one and the same device was renamed
or moved, which isn't the case here, I guess?

Kay
