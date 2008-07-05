Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYGEPYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYGEPYA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 11:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYGEPXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 11:23:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:54210 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYGEPXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 11:23:51 -0400
Date: Sat, 5 Jul 2008 08:23:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
Cc: "Kernel development list" <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: Battery life difference
Message-ID: <20080705082352.4b6be669@infradead.org>
In-Reply-To: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com>
References: <31e679430807050617u3fc706fasee9bb43a151c501f@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008 16:17:01 +0300
"Felipe Balbi" <felipebalbi@users.sourceforge.net> wrote:

> Hello all,
> 
> I bought two x61s for testing purposes. One of them is running
> windows XP and the other one is running clean ubuntu 8.04 with kernel
> 2.6.24-19. The problem is that on windows that battery lasts around
> 3h30min and with linux 1h30min.
> 
> 2 hours is a huge difference. Here's the scenario:
> 
> . x61s with windows xp
> wifi on but not connected to any network, bluetooth on,
> display is in the less brighten state.
> 
> . x61s with ubuntu 8.04
> all radios off (modules removed and hw switch off),

Which wireless is this? Same for graphics

> 
> Anyways, do we reach D2/D3 states anywhere ? I mean without
> context save/restore we can't reach D3 and almost no D2 as well.

these don't give you all that much nowadays
> 
> Any comments ?
> 

There's a few things you can do to help stuff along; make sure you're
using AHCI.

Also take a look at 
http://kerneltrap.org/mailarchive/linux-kernel/2008/5/8/1771024 because
these patches save like 0.75W in our lab.

To be honest, I'm surprised at your results; in our testing (with a
different distro though) we don't see such a difference and Linux is
doing rather well.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
