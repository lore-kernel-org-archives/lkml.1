Return-Path: <linux-kernel-owner+w=401wt.eu-S933581AbXBXXAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933581AbXBXXAN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 18:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933587AbXBXXAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 18:00:12 -0500
Received: from mxout-03.mxes.net ([216.86.168.178]:3856 "EHLO
	mxout-03.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933581AbXBXXAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 18:00:11 -0500
Message-ID: <33525.86.7.220.119.1172358010.squirrel@wmbeta.mxes.net>
In-Reply-To: <20070224030950.074f88d4.akpm@linux-foundation.org>
References: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net>
    <20070224030950.074f88d4.akpm@linux-foundation.org>
Date: Sat, 24 Feb 2007 23:00:10 -0000 (GMT)
Subject: Re: 2.6.21-rc1: framebuffer/console boot failure
From: "Andrew Nelless" <andrew@nelless.net>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Reply-To: "Andrew Nelless" <andrew@nelless.net>
User-Agent: SquirrelMail/1.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, February 24, 2007 11:09 am, Andrew Morton wrote:
>
> Presumably this regression was caused by the ACPI merge.  Are you able to
> capture the dmesg output from the 2.6.20-rc1 boot?  netconsole might be useful here, thanks.
>

I've confirmed a few things:

1) 2.6.21-rc1 actually will boot intermittently.
2) pci=noacpi always allows 2.6.21-rc1 to boot.
2) 2.6.20 always boots.
3) There doesn't seem to be a pattern (that I can tell) between booting and not booting,
although it'll now boot more often than not (It seemed very much t'other way around yesterday)
4) When 2.6.21-rc1 doesn't boot ('Boot'? Am i using the right term here? hmm...) nothing is
sent across netconsole at all.
5) Netconsole is useful.

I've uploaded all the dmesg output i've managed to capture here:
http://homepage.ntlworld.com/anelless/linux/2.6.21-rc1/

> (You get added to the post-2.6.20 regression list, so you'll be hearing
> from us quite a lot for the next month.  Sorry ;))
>

Lucky me :)

