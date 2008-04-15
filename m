Return-Path: <linux-kernel-owner+w=401wt.eu-S1765318AbYDOPv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765318AbYDOPv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 11:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760207AbYDOPve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 11:51:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57504 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760105AbYDOPvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 11:51:33 -0400
Date: Mon, 14 Apr 2008 22:37:06 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] tty: The big operations rework
Message-ID: <20080415053706.GD23965@kroah.com>
References: <20080413184011.7bd2f646@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413184011.7bd2f646@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 06:40:11PM +0100, Alan Cox wrote:
> - Operations are now a shared const function block as with most other
> Linux objects
> - Introduce wrappers for some optional functions to get consistent
> behaviour
> - Wrap put_char which used to be patched by the tty layer
> - Document which functions are needed/optional
> - Make put_char report success/fail
> - Cache the driver->ops pointer in the tty as tty->ops
> - Remove various surplus lock calls we no longer need
> - Remove proc_write method as noted by Alexey Dobriyan
> - Introduce some missing sanity checks where certain driver/ldisc
> combinations would oops as they didn't check needed methods were present
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Very nice, thanks for plugging away on this rework, it's really
appreciated.

If you want, you can add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patch.

thanks,

greg k-h
