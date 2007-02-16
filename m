Return-Path: <linux-kernel-owner+w=401wt.eu-S932420AbXBPBa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbXBPBa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 20:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932427AbXBPBa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 20:30:29 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42310 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420AbXBPBa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 20:30:27 -0500
Date: Thu, 15 Feb 2007 17:30:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@debian.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [patch 1/3] Input: psmouse - create PS/2 protocol options for
 Kconfig
Message-Id: <20070215173024.adc54d6c.akpm@linux-foundation.org>
In-Reply-To: <45D50101.60802@debian.org>
References: <45D43115.6060806@debian.org>
	<20070215164553.28f3f9af.akpm@linux-foundation.org>
	<45D50101.60802@debian.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 19:55:29 -0500
Andres Salomon <dilinger@debian.org> wrote:

> Andrew Morton wrote:
> > On Thu, 15 Feb 2007 05:08:21 -0500
> > Andres Salomon <dilinger@debian.org> wrote:
> > 
> >> Initial framework for disabling PS/2 protocol extensions.  The current
> >> protocols can only be disabled if CONFIG_EMBEDDED is selected.  No
> >> source files are changed, merely build stuff.
> > 
> > ugleee.  What benefit do we get for all this additional maintenance burden?
> 
> On any platform where you know exactly what ps/2 device you'll have
> plugged in, you can cut the size of psmouse.ko in half by disabling
> protocol extensions that are not in use.

hm, saving 4k or so.

Oh well, let's leave that up to Dmitry.

> For future protocol extension additions, we can add them without making
> the psmouse driver even larger.  We have one queued up for OLPC's
> touchpad which we'd like to get included in mainline, and it was made
> clear that being able to disable protocol extensions was a prerequisite
> for getting it included.  The OLPC ps/2 protocol extension would be
> disabled unless CONFIG_EMBEDDED and CONFIG_MOUSE_PS2_OLPC were both enabled.
> 
> See http://lkml.org/lkml/2006/9/11/200

Perhaps a nicer implementation would be to have a separate .c file for each
variant.
