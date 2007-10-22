Return-Path: <linux-kernel-owner+w=401wt.eu-S1753742AbXJVK5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbXJVK5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 06:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbXJVK53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 06:57:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44589 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbXJVK53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 06:57:29 -0400
Date: Mon, 22 Oct 2007 11:57:27 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: Christoph Hellwig <hch@infradead.org>, Henrik Carlqvist <hc1@poolhem.se>,
       linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
Message-ID: <20071022105727.GA22181@infradead.org>
References: <200710201257.55616.nick@ukfsn.org> <20071020144238.4f258c8c.hc1@poolhem.se> <20071022101107.GA20690@infradead.org> <471C7C33.4090003@ums.usu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471C7C33.4090003@ums.usu.ru>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 04:32:19PM +0600, Alexander E. Patrakov wrote:
> >That's wrong.   You can load firmware from the initramfs even if the
> >driver is built in.  There is no valid reason why a driver shouldn't
> >be allowed to be built in.
> 
> Could you please explain how this is supposed to work?
> 
> As far as I understand, the kernel initializes all built-in drivers, and 
> only then starts /init in initramfs (which is then supposed to start 
> udevd and load firmware) - but that's too late.

populate_rootfs is a rootfs_initcall which happens before all the driver
initcalls.
