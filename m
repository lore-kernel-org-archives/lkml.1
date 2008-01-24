Return-Path: <linux-kernel-owner+w=401wt.eu-S1753793AbYAXBdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793AbYAXBdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 20:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbYAXBc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 20:32:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43750 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYAXBc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 20:32:56 -0500
Date: Wed, 23 Jan 2008 17:37:20 -0800
From: Greg KH <greg@kroah.com>
To: Wilco Beekhuizen <wilcobeekhuizen@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Message-ID: <20080124013720.GA21978@kroah.com>
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2008 at 08:18:32PM +0100, Wilco Beekhuizen wrote:
> 2.6.24-rc8 (possibly lower rc's too) has usb_find_device removed from
> usb.c. This causes problems when compiling modules that need
> usb_find_device.
> This patch puts the symbol back in place. Unless someone has a good
> reason not to include usb_find_device?

I don't see any users in the kernel tree of this function that can be
built as a module.

Do you know of any external modules that need it?  Any pointers to the
code anywhere?

thanks,

greg k-h
