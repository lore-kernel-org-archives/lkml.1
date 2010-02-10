Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0BJN5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:57:40 -0500
Received: from cantor.suse.de ([195.135.220.2]:59845 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab0BJN5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:57:38 -0500
Date: Wed, 10 Feb 2010 14:57:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Michael Poole <mdpoole@troilus.org>
Cc: linux-input@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] Provide a driver for the Apple Magic Mouse
In-Reply-To: <87y6j2eeqv.fsf_-_@troilus.org>
Message-ID: <alpine.LNX.2.00.1002101456490.30967@pobox.suse.cz>
References: <alpine.LNX.2.00.1001291515560.356@pobox.suse.cz> <dd18b0c31002082322m4238a4a6m73fc30752ba30447@mail.gmail.com> <1265710460.2383.5685.camel@localhost.localdomain> <201002090736.55576.edt@aei.ca> <alpine.LNX.2.00.1002091339190.30967@pobox.suse.cz>
 <87y6j2eeqv.fsf_-_@troilus.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Feb 2010, Michael Poole wrote:

> I think this patch is ready for real review.  The Magic Mouse requires
> that a driver send an unlock Report(Feature) command, similar to the
> Wacom wireless tablet and Sixaxis controller quirks.  This turns on an
> Input Report that isn't published in the input Report descriptor that
> contains touch data (and usually overrides the normal motion and click
> Report).
> 
> Because the mouse has only one switch and no scroll wheel, the driver
> (under control of parameters) emulates a middle button and scroll wheel.
> User space could also ignore and/or re-synthesize those events based on
> the reported events.
> 
> The first patch exports hid_register_report() so the driver can turn on
> the multitouch report.  The second patch adds the device ID and the
> driver.  Some user-space tools to talk to the mouse directly (that is,
> when it is not associated with the host's HIDP stack) are at
> http://github.com/entrope/linux-magicmouse .

I have applied the driver into apple_magic_mouse branch and merged this 
branch into for-next, so it should appear in the upcoming linux-next.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
