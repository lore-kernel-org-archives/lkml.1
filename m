Return-Path: <linux-kernel-owner+w=401wt.eu-S1759514AbZAUSJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbZAUSJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 13:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZAUSIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 13:08:40 -0500
Received: from kroah.org ([198.145.64.141]:42452 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754377AbZAUSIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 13:08:39 -0500
Date: Wed, 21 Jan 2009 09:41:46 -0800
From: Greg KH <greg@kroah.com>
To: David Altobelli <david.altobelli@hp.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] hpilo open/close fix
Message-ID: <20090121174146.GD3991@kroah.com>
References: <20090112201837.GA19499@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112201837.GA19499@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 01:18:37PM -0700, David Altobelli wrote:
> Fix to hpilo module, patch against 2.6.28.
> The device can take a while to respond to an open/close request, so increase
> the time kernel will wait for response (1 ms to 10ms).  
> Also, properly clean up a channel on a failed open, by calling the 
> channel close routine.  Just freeing the memory isn't sufficient, the device
> needs to be informed that the channel is no longer open, and the device
> memory cleared of references to freed dma buffer.
> 
> Please CC me on any replies.
> 
> Signed-off-by: David Altobelli <david.altobelli@hp.com>

Am I supposed to be shepharding patches to drivers/misc/hpilo into the
kernel tree?  If so, I've been ignoring it, sorry.  Is there any becides
this one that you need to go in?

thanks,

greg k-h
