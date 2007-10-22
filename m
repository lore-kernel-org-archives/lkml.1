Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbXJVMxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbXJVMxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 08:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbXJVMxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 08:53:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42040 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbXJVMxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 08:53:38 -0400
Date: Mon, 22 Oct 2007 13:53:34 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: Christoph Hellwig <hch@infradead.org>, Henrik Carlqvist <hc1@poolhem.se>,
       linux-kernel@vger.kernel.org
Subject: Re: tristate and bool not enogh for Kconfig anymore
Message-ID: <20071022125334.GA10563@infradead.org>
References: <200710201257.55616.nick@ukfsn.org> <20071020144238.4f258c8c.hc1@poolhem.se> <20071022101107.GA20690@infradead.org> <471C7C33.4090003@ums.usu.ru> <20071022105727.GA22181@infradead.org> <471C8937.9010007@ums.usu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471C8937.9010007@ums.usu.ru>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 05:27:51PM +0600, Alexander E. Patrakov wrote:
> Yes, there is a call to usermodehelper_init() before the initcalls in 
> do_basic_setup(), this does mean that firmware can be loaded by means of 
> the old and obsolete /sbin/hotplug mechanism, but who has /sbin/hotplug now?

I do.  We're not going to cripple the kernel just because you use fucked
up userspace.

