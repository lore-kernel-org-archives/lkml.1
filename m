Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbZKZKGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbZKZKGH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754298AbZKZKGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:06:06 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:55295 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbZKZKGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:06:05 -0500
Date: Thu, 26 Nov 2009 11:05:00 +0100
From: Anisse Astier <anisse@astier.eu>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: i8042 - add Dell Vostro 1520 and 1720 to the
 reset list
Message-ID: <20091126110500.735461ac@destiny.ordissimo>
In-Reply-To: <20091124151250.03e185d1@destiny.ordissimo>
References: <20091124151250.03e185d1@destiny.ordissimo>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Sorry for the badly threaded reply, I wasn't subscribed to the list and
didn't ask explicitely to be Cc-ed.

>On Wed, 25 Nov 2009 12:17:37 -0800, Dmitry Torokhov wrote:
>Could youplease explain in more detail what the "bad state" is.
>And what exactly do you mean by "first boot"? Cold boot? The very
>first boot after assembling? Something else?

By bad state I mean that neither touchpad nor keyboard are working. They
are both unresponsive. You can fix this by adding i8042.reset on the
kernel command line, or removing the battery and waiting long enough.
By very first boot I mean when the laptops are received from Dell and
booted in Linux.

If you cold boot with a working non-Dell power supply (with same
electrical characteristics), you can reproduce the "first boot" bug as
much as you want, and laptops won't work unless you remove the battery
and wait long enough OR add i8042.reset on the cmdline.

Regards,

--
Anisse
