Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbZEFPl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbZEFPl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbZEFPlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:41:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60084 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754477AbZEFPlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:41:46 -0400
Date: Wed, 6 May 2009 16:42:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Jason Wessel <jason.wessel@windriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
 writes
Message-ID: <20090506164235.631230f7@lxorguk.ukuu.org.uk>
In-Reply-To: <20090506152521.GA4603@kroah.com>
References: <1241575205-12199-6-git-send-email-jason.wessel@windriver.com>
	<Pine.LNX.4.44L0.0905061058230.3227-100000@iolanthe.rowland.org>
	<20090506152521.GA4603@kroah.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Or if you do, just bump up the number outstanding urbs that are
> possible.  Or the urb buffer size.

Simply growing the urb size and urb count isn't the right way to
fix this, it just uses more memory to pretend to paper over it.
