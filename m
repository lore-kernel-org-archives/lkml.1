Return-Path: <linux-kernel-owner+w=401wt.eu-S1764742AbYBZUEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764742AbYBZUEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754469AbYBZUEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:04:25 -0500
Received: from mercury.sdinet.de ([193.103.161.30]:43612 "EHLO
	mercury.sdinet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYBZUEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:04:25 -0500
X-Greylist: delayed 907 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2008 15:04:24 EST
Date: Tue, 26 Feb 2008 20:49:15 +0100 (CET)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: rzryyvzy <rzryyvzy@trashmail.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: Is there a memory block device?
In-Reply-To: <20080226185336.9771B58477AE1@trashmail.net>
Message-ID: <alpine.DEB.1.00.0802262044120.2694@mercury.sdinet.de>
References: <20080226185336.9771B58477AE1@trashmail.net>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, rzryyvzy wrote:

> I know that tmpfs is a memmory filesystem. Is there a possibility to 
> create also a memory block device?
> Is there a possibility to create for example a 1 GB memory block device 
> (from the RAM)?

There are the /dev/ram* devices, created through kernel config 
CONFIG_BLK_DEV_RAM (RAM disk support), kernel module rd.ko

But I'm not sure how to configure their size besides setting the kernel 
config option, it's a long time ago that I used them last.

c'ya
sven

-- 

The Internet treats censorship as a routing problem, and routes around
it. (John Gilmore on http://www.cygnus.com/~gnu/)
