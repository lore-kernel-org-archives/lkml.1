Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbXLKWMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbXLKWMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:12:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbXLKWLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:11:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53522 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751232AbXLKWLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:11:52 -0500
Date: Tue, 11 Dec 2007 14:10:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: mbligh@google.com, linux-kernel@vger.kernel.org, apw@shadowen.org,
       netdev@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Subject: Re: 2.6.24-rc4-mm1
Message-Id: <20071211141040.a1c6f316.akpm@linux-foundation.org>
In-Reply-To: <475F00A2.6020406@intel.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	<33307c790712110813h23def95dvd068b7226e9fcd36@mail.gmail.com>
	<20071211123705.844aac24.akpm@linux-foundation.org>
	<475F00A2.6020406@intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 13:26:58 -0800
"Kok, Auke" <auke-jan.h.kok@intel.com> wrote:

> Andrew Morton wrote:
> > On Tue, 11 Dec 2007 08:13:52 -0800 "Martin Bligh" <mbligh@google.com> wrote:
> > 
> >>>
> >>> - Lots of device IDs have been removed from the e1000 driver and moved
> >>> over
> >>>  to e1000e.  So if your e1000 stops working, you forgot to set
> >>> CONFIG_E1000E.
> >>>
> >>>
> >> Wouldn't it make sense to just default this to on if E1000 was on, rather
> >> than screwing
> >> everybody for no good reason (plus breaking all the automated testing, etc
> >> etc)?
> >> Much though I love random refactoring, it is fairly painful to just keep
> >> changing the
> >> names of things.
> > 
> > (cc netdev and Auke)
> > 
> > Yes, that would be very sensible.  CONFIG_E1000E should default to whatever
> > CONFIG_E1000 was set to.
> 
> which is "y" for x86 and friends, ppc, arm and ia64 through 'defconfig'. the
> Kconfig files do not have defaults in them.

I wouldn't be looking at defconfig files - I don't think many people use
them.  Most people use their previous config, via oldconfig.

So what we want here is to give them E1000E if they had previously been
using E1000.  I don't know how one would do this in Kconfig.

