Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbYE0SYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbYE0SYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 14:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbYE0SYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 14:24:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59750 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758116AbYE0SYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 14:24:36 -0400
Date: Tue, 27 May 2008 11:05:44 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH 00/20] Implment a tty port structure and supporting
	logic
Message-ID: <20080527180544.GC23505@kroah.com>
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

On all of these patches, you did not add a "Signed-off-by:".  Was that
on purpose and you do not want these patches applied, or unintentional?

thanks,

greg k-h
