Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZELVte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZELVte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 17:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbZELVtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 17:49:25 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:37231 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZELVtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 17:49:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i2zyevgvKqnTU0RLsb55eTePmrtSfFoQu32RzwGoEh8I6jbeSJTu2fAa098x8IwPTM
         2KxCh3Ef0O4hDiyGdb1Q0FWyyJA5j03B+Nx4oKY651gLN2b5mZd0jt2IfD2p9RGD137J
         zqszlbuNHWOrM+bPb4C9xycXDbOgyVzaPycYE=
MIME-Version: 1.0
In-Reply-To: <f74141980905121422p140d1649jcfb3d94aacd42f02@mail.gmail.com>
References: <f74141980905121422p140d1649jcfb3d94aacd42f02@mail.gmail.com>
Date: Wed, 13 May 2009 01:49:24 +0400
Message-ID: <a4423d670905121449p3f1112d3rf2e4a1e57cd076e@mail.gmail.com>
Subject: Re: jsm: two or more 4/8-port boards can not initialize ports 
	properly
From: Alexander Beregalov <a.beregalov@gmail.com>
To: "Alexander Y. Fomichev" <git.user@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/13 Alexander Y. Fomichev <git.user@gmail.com>:
> G' day
>
> The patch bellow fix for me problem with jsm_uart_port_init
> which still thinking it works for 2-ports borads only.
> drivers/serial/jsm/jsm_tty.c +462
> brd->channels[i]->uart_port.line = brd->channels[i]->ch_portnum +
> brd->boardnum * 2;
>
>                         ^^^^^^^^^^^^^^^^^^^^^^
> so for line numbers of the second and further boards
> may/will be assigned values with the same range.
> in my case of two digi neo-8 -- 6 ports of 8 failed to be
> added for the second board.

Hi Alexander,

Your patch is broken, your mail client wraps long lines.
Please read Documentation/email-clients.txt.
Please add linux-serial@vger.kernel.org,
alan@lxorguk.ukuu.org.uk and Scott.Kilau@digi.com to CC list.
Please add Signed-off-by line as described in Documentation/SubmittingPatches
