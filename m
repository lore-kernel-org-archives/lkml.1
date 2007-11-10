Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbXKJPlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbXKJPlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 10:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbXKJPlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 10:41:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51141 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbXKJPlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 10:41:07 -0500
From: Frank Seidel <fseidel@suse.de>
Organization: SUSE LINUX Products GmbH
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC 1/13] Char: nozomi, remove unneded stuff
Date: Sat, 10 Nov 2007 16:41:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
References: <10551261882075921134.slaby@pripojeni.net>
In-Reply-To: <10551261882075921134.slaby@pripojeni.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711101641.03858.fseidel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Samstag 10 November 2007 00:43:29, you (Jiri Slaby) wrote:
> Frank, could you comment (and test) following changes to the nozomi driver?
> I did them before you post the updated version and rediffed them a while
> ago, I hope I haven't done any mistake while doing it.

Great thanks for all this! I went through all of them,
put some comments in, ran tests and incorporated them
(nearly completely and unchanged).
They really catched a great number of issues.

I also added you to the header of the complete patch
(also with your Signed-off-by), is that ok?
After some final tests are through i'll repost the complete patch in
the review thread and in CC to Greg again.

> --
> 
> nozomi, remove unneded stuff
> 
> - tty_termios* are set to tty struct, but tty_register_driver overwrites it
>   with its own values (or NULLs), no need to have these pointers stored
> - [rt]x_data are updated but never used

completely agree

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> ---
all applied without a change

Many thanks again,
Frank
