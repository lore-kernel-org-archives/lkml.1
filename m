Return-Path: <linux-kernel-owner+w=401wt.eu-S1756787AbZC0VoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787AbZC0VoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZC0VoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:44:09 -0400
Received: from vena.lwn.net ([206.168.112.25]:35572 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZC0VoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:44:08 -0400
Date: Fri, 27 Mar 2009 15:44:03 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
       eteo@redhat.com
Subject: Re: [patch] char/raw.c locking on error
Message-ID: <20090327154403.4712afe3@bike.lwn.net>
In-Reply-To: <49CD46C8.8040606@msgid.tls.msk.ru>
References: <Pine.LNX.4.64.0903262243150.4167@usbsys.site>
	<20090327094812.32d0d5e7@bike.lwn.net>
	<49CD46C8.8040606@msgid.tls.msk.ru>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009 00:36:08 +0300
Michael Tokarev <mjt@tls.msk.ru> wrote:

> Is it still in use - the raw driver, that is?  Nowadays,
> every block device can be opened in direct mode by using
> O_DIRECT - this is what raw does.  I mean, is it worth
> spending even more time on it?

This was discussed a while back.  My understanding is that there are
people using it.  It is a user-space ABI of sorts which can't just be
yanked arbitrarily.  The right thing to do is probably to replace it
with a shell implementation that just opens the device using O_DIRECT,
but nobody has actually done that...

jon
