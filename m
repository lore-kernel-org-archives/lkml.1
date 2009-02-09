Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbZBITCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbZBITCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 14:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbZBITBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 14:01:55 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49979 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbZBITBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 14:01:55 -0500
Date: Mon, 9 Feb 2009 19:01:42 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Davide Rizzo <elpa.rizzo@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, ben-linux@fluff.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH 1/2] User access to internal clocks
Message-ID: <20090209190142.GD19453@n2100.arm.linux.org.uk>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com> <20090209171042.GA19453@n2100.arm.linux.org.uk> <8447d6730902090944s9bc96f7r76da82ea09c629f0@mail.gmail.com> <20090209175514.GB19453@n2100.arm.linux.org.uk> <8447d6730902091017m21cb30d0w6be6fbbbf33db4f3@mail.gmail.com> <8447d6730902091054x7c4c842m7339382e19260bd8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8447d6730902091054x7c4c842m7339382e19260bd8@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 07:54:57PM +0100, Davide Rizzo wrote:
> > What about adding a dedicated function to clk api that registers a struct clk
> >  in a linked list and associates it with a name, with the only specific purpose
> >  to enumerate and list (and possibly change rate and parents) all
> > clocks in sysfs ?
> > Obviously only specifically registered clocks will be visible in sysfs...
> >
> 
> Or better, only proposed functions:
> int clk_for_each(int(*fn)(struct clk *, void *), void *data)
> and
> const char *clk_sysname(struct clk *)
> need to be added to clk api, the function to register the struct clk
> in the linked list could be implementation specific.
> Maybe a function like this:
> struct clk *clk_get_by_sysname(const char *sysname);
> could be useful to be added to api interface, too ?

I'm not going to reply unless you copy your replies to linux-arm-kernel.
By not copying that list, you're excluding maintainers for quite a number
of implementation maintainers from this discussion.
