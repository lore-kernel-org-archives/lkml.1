Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbZC1AXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbZC1AXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbZC1AW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:22:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43803 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751310AbZC1AW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:22:58 -0400
Date: Sat, 28 Mar 2009 00:23:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Jonathan Corbet <corbet@lwn.net>, Dan Carpenter <error27@gmail.com>,
       linux-kernel@vger.kernel.org, eteo@redhat.com
Subject: Re: [patch] char/raw.c locking on error
Message-ID: <20090328002329.25730798@lxorguk.ukuu.org.uk>
In-Reply-To: <49CD46C8.8040606@msgid.tls.msk.ru>
References: <Pine.LNX.4.64.0903262243150.4167@usbsys.site>
	<20090327094812.32d0d5e7@bike.lwn.net>
	<49CD46C8.8040606@msgid.tls.msk.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Mar 2009 00:36:08 +0300
Michael Tokarev <mjt@tls.msk.ru> wrote:

> Jonathan Corbet wrote:
> > (I bet raw doesn't need BKL at all; I'll see if I can't find some time
> > to have a look later on).
> 
> Is it still in use - the raw driver, that is?  Nowadays,
> every block device can be opened in direct mode by using
> O_DIRECT - this is what raw does.  I mean, is it worth
> spending even more time on it?

Certainly when I worked for a vendor there were some big proprietary
applications using the raw interface both because it was an established
API and also because it mirrorred various Unixen and relatives they also
ran the apps on with the same basic code.

Attempts to kill it were met with pretty forceful objections.

