Return-Path: <linux-kernel-owner+w=401wt.eu-S933891AbZHEJPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933891AbZHEJPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933832AbZHEJPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:15:17 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38697 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932925AbZHEJPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:15:16 -0400
Date: Wed, 5 Aug 2009 10:15:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <teheo@suse.de>
Cc: Greg KH <greg@kroah.com>, Al Viro <viro@ftp.linux.org.uk>,
       Takashi Iwai <tiwai@suse.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>, cguthrie@mandriva.org
Subject: Re: [PATCH 2/2] sound: make OSS device number claiming optional
Message-ID: <20090805101551.6ee053e5@lxorguk.ukuu.org.uk>
In-Reply-To: <4A79296A.4090600@suse.de>
References: <4A79283E.7030202@kernel.org>
	<4A79296A.4090600@suse.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Aug 2009 15:40:42 +0900
Tejun Heo <teheo@suse.de> wrote:

> If any OSS support is enabled, regardless of built-in or module,
> sound_core claims full OSS major number (that is, the old 0-255
> region) to trap open attempts and request sound module automatically.
> This feature is redundant as chrdev already has such mechanism and no
> longer used by modern distros.  This preemptive claiming prevents
> alternative OSS implementation.
> 
> This patch makes the preclaiming optional and adds a config option
> SOUND_OSS_CORE_PRECLAIM and kernel parameter soundcore.preclaim_oss to
> control whether preclaim is enabled or not.  This allows distros and
> developers to try new things without rebuilding kernel.

This looks like a random private devel hack sand I don't see why it's
appropriate for mainstream, especially as these "new things" don't exist
mainstream either.
