Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbYD2W6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbYD2W6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbYD2W6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:58:31 -0400
Received: from mail.queued.net ([207.210.101.209]:1651 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbYD2W6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:58:30 -0400
Date: Tue, 29 Apr 2008 19:01:37 -0400
From: Andres Salomon <dilinger@queued.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: olpc_battery_trigger_uevent() is unused
Message-ID: <20080429190137.5b519463@ephemeral>
In-Reply-To: <20080429222951.GB15987@cs181133002.pp.htv.fi>
References: <20080429222951.GB15987@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 01:29:51 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> drivers/power/olpc_battery.c:olpc_battery_trigger_uevent() is unused.
> 
> Should it have been used?
> 
> cu
> Adrian
> 

It will get used once the olpc power management code makes it
upstream.  The olpc_register_battery_callback stuff that Andrew removed
was related to that.

Remove it now if you like, but I'm hoping to get it in for the 2.6.27
merge window.
