Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbXKJPlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbXKJPlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbXKJPl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:41:27 -0500
Received: from ns.suse.de ([195.135.220.2]:60875 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbXKJPlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:41:25 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 3/13] Char: nozomi, fix fail paths
Date: Sat, 10 Nov 2007 16:41:22 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <97452711637819007.slaby@pripojeni.net>
In-Reply-To: <97452711637819007.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101641.23423.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:44:50, you (Jiri Slaby) wrote:
> nozomi, fix fail paths
> 
> Free resources on fail path in probe function properly (free_irq,
> remove_sysfs_files, kfifo_free, kfree(dc->send_buf) and atomic_dec). Also
> use kfifo_free instead of kfree on release function, because it leaked
> fifo->buffer.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

all applied without change

Thanks,
Frank
