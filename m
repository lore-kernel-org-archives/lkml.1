Return-Path: <linux-kernel-owner+w=401wt.eu-S1760316AbYESQvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316AbYESQvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 12:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbYESQv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 12:51:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42701 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbYESQvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 12:51:25 -0400
Date: Mon, 19 May 2008 09:50:49 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 00/20] Implment a tty port structure and supporting
	logic
Message-ID: <20080519165049.GA19896@kroah.com>
References: <20080519144557.19326.74313.stgit@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080519144557.19326.74313.stgit@core>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 03:50:07PM +0100, Alan Cox wrote:
> Right now each tty has its own port level structure which means we can share
> no code between ports. Introduce a structure and some initial minor helper
> routines so that we can move towards commonality. In doing this the USB serial
> code gets a bit of shake up as it kept using port->tty unsafely. Fixing that
> means changing the API of all the USB serial drivers. On the bright side the
> API now looks far more like the tty layer API which will become useful later
> on.

Very nice.

If you don't mind, I'll be glad to take this through my tree as you are
touching the usb-serial drivers so much.  Andrew, any objection to this?

>  MAINTAINERS                           |   72 +

Odd, I don't see you modifing this file in your patch series...

thanks,

greg k-h
