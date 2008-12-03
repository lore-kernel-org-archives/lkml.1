Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbYLCPSN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbYLCPSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:18:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYLCPR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:17:58 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:14562 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYLCPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:17:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=mHB2M4jWub2yIi3ADKN7M8hxeHbKgOamAHSlIfctFw7ab5vDAQQFHzm8uP4QEqjf13
         hhGZ4RYNHzHjCMkbCeVfkfVWFDzk+QL44EgMzEAonjnDtx2exgn2bdgb2gBfU1f6Cg9l
         RoKNge52yKQiI0DuGMxIKocvPgDlCAk7uiknk=
Message-ID: <4936A320.3050801@gmail.com>
Date: Wed, 03 Dec 2008 16:17:52 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Char: n_tty, include module.h
References: <1228307338-18467-1-git-send-email-jirislaby@gmail.com> <20081203124300.3f03dec8@lxorguk.ukuu.org.uk>
In-Reply-To: <20081203124300.3f03dec8@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2008 01:43 PM, Alan Cox wrote:
> On Wed,  3 Dec 2008 13:28:58 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Since we are using EXPORT_SYMBOL, we should include linux/module.h
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> 
> NAK
> 
> n_tty doesn't use EXPORT_SYMBOL.

Sure it does. Maybe the patch didn't come to you yet. Will repost to akpm as a
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch fix.

$ grep EXPORT drivers/char/n_tty.c
EXPORT_SYMBOL_GPL(n_tty_flush_buffer);
EXPORT_SYMBOL_GPL(n_tty_chars_in_buffer);
EXPORT_SYMBOL_GPL(n_tty_write_wakeup);
EXPORT_SYMBOL_GPL(n_tty_receive_buf);
EXPORT_SYMBOL_GPL(n_tty_set_termios);
EXPORT_SYMBOL_GPL(n_tty_close);
EXPORT_SYMBOL_GPL(n_tty_open);
EXPORT_SYMBOL_GPL(n_tty_read);
EXPORT_SYMBOL_GPL(n_tty_write);
EXPORT_SYMBOL_GPL(n_tty_poll);

