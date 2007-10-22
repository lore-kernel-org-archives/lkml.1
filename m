Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbXJVKLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbXJVKLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbXJVKLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:11:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59688 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbXJVKLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:11:09 -0400
Date: Mon, 22 Oct 2007 11:11:08 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Henrik Carlqvist <hc1@poolhem.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
Message-ID: <20071022101107.GA20690@infradead.org>
References: <200710201257.55616.nick@ukfsn.org> <20071020144238.4f258c8c.hc1@poolhem.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020144238.4f258c8c.hc1@poolhem.se>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 02:42:38PM +0200, Henrik Carlqvist wrote:
> I think there is a need for Kconfig to specify that a functionality could
> be built as a module or not built at all.
> 
> Some drivers require that firmware is loaded when the driver is
> initialized. The kernel has functionalities for this by using a userspace
> program. However, this userspace program is only usable from modules and
> not during boot while any initrd or any other file system has not yet been
> mounted and yet less any processes started.

That's wrong.   You can load firmware from the initramfs even if the
driver is built in.  There is no valid reason why a driver shouldn't
be allowed to be built in.

