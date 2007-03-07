Return-Path: <linux-kernel-owner+w=401wt.eu-S965570AbXCGQwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965570AbXCGQwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:52:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965580AbXCGQwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:52:12 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:41203 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965570AbXCGQwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:52:09 -0500
Message-ID: <45EEED5C.1090902@gmail.com>
Date: Wed, 07 Mar 2007 17:50:36 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Jon Ringle <JRingle@vertical.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: tiny tty driver sample
References: <4DD3AF7ECBBC43409BA36508938D0185123A35@CVAEX1.VERTICAL.COM>
In-Reply-To: <4DD3AF7ECBBC43409BA36508938D0185123A35@CVAEX1.VERTICAL.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 07 Mar 2007 17:51:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Ringle napsal(a):
> Hello,
> 
> I'm trying to write a tty driver and I'm using
> http://lwn.net/images/pdf/LDD3/ch18.pdf as a guide. The sample tiny tty
> driver includes the following code:
> 
>             for (i = 0; i < data_size; ++i) {
>                         if (tty->flip.count >= TTY_FLIPBUF_SIZE)
>                                     tty_flip_buffer_push(tty);
>                         tty_insert_flip_char(tty, data[i], TTY_NORMAL);
>             }
>             tty_flip_buffer_push(tty);
> 
> This doesn't compile against Linux 2.6.16 kernel I'm using, because
> tty->flip.count doesn't exist anymore.
> How should this sample be re-coded?

I think this way:
http://lkml.org/lkml/2007/2/17/65

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
