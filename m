Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbXKGXV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbXKGXV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 18:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbXKGXVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 18:21:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46904 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756278AbXKGXVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 18:21:49 -0500
Date: Wed, 7 Nov 2007 15:21:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Gerhard Mack <gmack@innerfire.net>
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@suse.cz>,
       Takashi Iwai <tiwai@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.24-rc2 breaks nVidia MCP51 High Definition Audio
Message-Id: <20071107152127.6d012c6c.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.0.999.0711071737030.552@mtl.rackplans.net>
References: <alpine.DEB.0.999.0711071737030.552@mtl.rackplans.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 7 Nov 2007 17:39:41 -0500 (EST) Gerhard Mack <gmack@innerfire.net> wrote:
> hello,
> 
> This worked fine in 2.6.23 but now the kernel no longer sees my audio 
> controller.
> 
> 00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev 
> a2)
> 00:10.1 0403: 10de:026c (rev a2)
> 
> Let me know if I can provide more info or test patches.
> 

Please provide the output of `dmesg -s 1000000' for both 2.6.23
and 2.6.24-rc3, thanks.

Are you sure that the driver is suitably configured?  Sometimes
we like to fiddle config options so that a `make oldconfig' will go and
unconfigure drivers which you need.
