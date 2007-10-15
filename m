Return-Path: <linux-kernel-owner+w=401wt.eu-S1759105AbXJOWXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759105AbXJOWXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 18:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbXJOWW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 18:22:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45209 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413AbXJOWWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 18:22:55 -0400
Date: Mon, 15 Oct 2007 15:22:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: bryan.wu@analog.com, dmitry.torokhov@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Blackfin serial driver: this driver enable SPORTs
 on Blackfin emulate UART
Message-Id: <20071015152245.12d29f8b.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0710151503u4b57dd4aoc4b50d936e17adb0@mail.gmail.com>
References: <1192098220-25828-1-git-send-email-bryan.wu@analog.com>
	<1192098220-25828-4-git-send-email-bryan.wu@analog.com>
	<20071015133326.995a4f38.akpm@linux-foundation.org>
	<8bd0f97a0710151503u4b57dd4aoc4b50d936e17adb0@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 18:03:35 -0400
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> > It is not a good idea to create files in /proc which have spaces in their
> > names.  Yes, userspace _should_ be able to cope with that in all cases, but
> > all software sucks, even including userspace ;)
> >
> > I'd suggest that we be defensive here, and avoid using spaces in filenames.
> 
> i'm not sure i follow ... these are the names given to request_irq()
> which means this is what shows up in /proc/interrupts ... does this
> function also create an actual file somewhere in /proc that i am not
> aware of ?

err, umm, yeah.  But the same argument applies: it is imprudent to have
space-containing records in /proc/interrupts.

However it seems that we've already done that in several places so I guess
any /proc/interrupts-parsing programs are already coping with it OK.
