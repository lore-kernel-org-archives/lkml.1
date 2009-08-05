Return-Path: <linux-kernel-owner+w=401wt.eu-S934118AbZHEJ7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118AbZHEJ7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:59:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933345AbZHEJ7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:59:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36603 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933246AbZHEJ7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:59:51 -0400
Date: Wed, 5 Aug 2009 11:00:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <teheo@suse.de>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
Message-ID: <20090805110031.51424dbe@lxorguk.ukuu.org.uk>
In-Reply-To: <4A7951B0.10208@suse.de>
References: <4A79283E.7030202@kernel.org>
	<4A79296A.4090600@suse.de>
	<20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
	<4A7951B0.10208@suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Aug 2009 18:32:32 +0900
Tejun Heo <teheo@suse.de> wrote:

> Hello, Alan.
> 
> Alan Cox wrote:
> > This looks like a random private devel hack sand
> 
> Why so?
> 
> > I don't see why it's appropriate for mainstream, especially as these
> > "new things" don't exist mainstream either.
> 
> The new things is CUSE and it's already in mainstream.

Then fix it to use the sound interfaces properly. We have a multiplexor
for sound devices so they can be shared between OSS/ALSA/whatever. Use it.
Ditto if you want CUSE to handle miscdevices use the miscdevice interface
properly.

