Return-Path: <linux-kernel-owner+w=401wt.eu-S1753437AbXKJPmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbXKJPmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXKJPls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:41:48 -0500
Received: from ns.suse.de ([195.135.220.2]:60932 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbXKJPlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:41:47 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 4/13] Char: nozomi, tty index cleanup
Date: Sat, 10 Nov 2007 16:41:43 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <2351011721234832519.slaby@pripojeni.net>
In-Reply-To: <2351011721234832519.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101641.44700.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:45:30, you (Jiri Slaby) wrote:
> nozomi, tty index cleanup
> 
> - don't store unneeded copy of tty->index into port structure, tty->index
>   is available everywhere
> - mod tty->index by MAX_PORT where expected (otherwise array index out of
>   bounds)
The last point i can't retrace, as all those parts were already IMHO.
NTTY_TTY_MINORS is just an alias for MAX_PORT, but of course its much 
better readable and also shorter. But i doubt this prevents to an array
index to get out of bounds ;-)

but all applied without a change

Thanks,
Frank
