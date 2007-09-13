Return-Path: <linux-kernel-owner+w=401wt.eu-S1763918AbXIMFJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763918AbXIMFJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 01:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXIMFJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 01:09:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35368 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbXIMFJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 01:09:09 -0400
Message-ID: <46E8C5F2.4080009@garzik.org>
Date: Thu, 13 Sep 2007 01:09:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Kees Cook <kees@ubuntu.com>
CC: linux-kernel@vger.kernel.org, Ben Collins <bcollins@ubuntu.com>
Subject: Re: [PATCHv2] misc: fix unterminated *_device_id lists
References: <20070913004709.GL8183@outflux.net> <46E88F1B.5050405@garzik.org> <20070913035407.GN8183@outflux.net> <46E8B64D.3030107@garzik.org> <20070913044504.GP8183@outflux.net>
In-Reply-To: <20070913044504.GP8183@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> Fixes drivers that do not correctly terminate their *_device_id lists.
> This results in garbage being spewed into modules.pcimap when the module
> happens to not have 28 NULL bytes following the table, and/or the last PCI
> ID is actually truncated from the table when calculating the modules.alias
> PCI aliases, causing those unfortunate device IDs to not auto-load.
> 
> Signed-off-by: Kees Cook <kees@ubuntu.com>
> ---
> Re-send, using recommended list termination code-style.
> Diff is against 2.6.23-rc6.

ACK


