Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbXJVO24@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbXJVO24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 10:28:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbXJVO2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 10:28:48 -0400
Received: from the.earth.li ([193.201.200.66]:43696 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbXJVO2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 10:28:47 -0400
Date: Mon, 22 Oct 2007 15:28:46 +0100
From: Jonathan McDowell <noodles@earth.li>
To: John Belmonte <john@neggie.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add bluetooth support to toshiba-acpi driver
Message-ID: <20071022142845.GL1880@earth.li>
References: <20071021173529.GH1880@earth.li> <471C88E2.3020102@neggie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <471C88E2.3020102@neggie.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 07:26:26AM -0400, John Belmonte wrote:
> > This patch adds bluetooth support to the toshiba-acpi driver. I have
> > tried to follow the same format for the /proc/acpi/toshiba/bluetooth
> > file as followed in the thinkpad-acpi driver. In the long term the
> > rfkill infrastructure looks like the way forward for this functionality,
> > but at present it doesn't seem to be suitable.
> >
> > Traditionally the userland "toshset" program would have been used to
> > enable bluetooth, but this requires either CONFIG_TOSHIBA or a patched
> > toshiba-acpi to emulate the /dev/toshiba device. Also toshset doesn't
> > currently run in 64bit mode.
> >
> > Patch has been successfully tested on a Portégé R200 (in 32bit mode) and
> > an R500 (in 64bit mode).
> >
> > Signed-Off-By: Jonathan McDowell <noodles@earth.li>
> 
> The /proc/acpi/toshiba interface should not be expanded-- do not apply
> this patch.  If any patch is applied, it would be to optionally
> implement the generic /dev/toshiba interface so that user space tools
> like toshset can operate.

There's been a patch to add the /dev/toshiba functionality floating
around for at least a year or two. Is there a reason it hasn't already
been applied?

I'm not entirely convinced that userland is the right way to do this
though. In the long run rfkill appears to be the correct generic
infrastructure, but at present it's not able to cope with devices that
don't exist when switched off and I can't find any other users in
mainline anyway. Assuming that changes, would you accept a patch adding
support for it to toshiba-acpi?

J.

-- 
                                            jid: noodles@jabber.earth.li
I had a life once... but now I have a
                                            modem.
