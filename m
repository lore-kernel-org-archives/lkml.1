Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbXKJPnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbXKJPnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbXKJPm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:42:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:51315 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501AbXKJPm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:42:27 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 8/13] Char: nozomi, tty cleanup
Date: Sat, 10 Nov 2007 16:42:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <15624318902788326176.slaby@pripojeni.net>
In-Reply-To: <15624318902788326176.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101642.25347.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:48:11, you (Jiri Slaby) wrote:
> nozomi, tty cleanup
> 
> - init and deinit tty driver at module load/unload. When the OS (user)
>   loads the driver the hardware usually is ready to driver.
> - merge (unify) MAX_PORT, NTTY_TTY_MINORS into NOZOMI_MAX_PORTS
> - remove struct nozomi_devices, it was used only as list entries

Oh, i fear this patch makes some issues (e.g. changing NOZOMI_MAX_PORTS
without adapting all its usages).. as this one (together with [RFC 7/13])
is quite big and i really don't wanna loose the multicard support (which
i also cannot test yet here at home), 
i'd defer those two until next week when i get a chance to test and have
more time.

Thanks,
Frank


