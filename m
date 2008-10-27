Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbYJ0Tst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbYJ0Tst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYJ0Tsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:48:40 -0400
Received: from kroah.org ([198.145.64.141]:48670 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751289AbYJ0Tsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:48:39 -0400
Date: Mon, 27 Oct 2008 11:37:08 -0700
From: Greg KH <greg@kroah.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] w35und: remove dead code from wbusb_f.h
Message-ID: <20081027183707.GA13737@kroah.com>
References: <Pine.LNX.4.64.0810221906140.1679@melkki.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810221906140.1679@melkki.cs.Helsinki.FI>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 07:06:41PM +0300, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Remove dead code from wbusb_f.h and move the WbWLanInitialize() definition to
> wblinux_f.h where it arguably belongs to. As the wbusb_f.h is now empty, we can
> remove it completely.
> 
> Cc: Pavel Machek <pavel@suse.cz>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

This patch gives me a bunch of build errors as I don't think you are in
sync with the other changes in these files.

Care to respin it against 2.6.28-rc2?

thanks,

greg k-h
