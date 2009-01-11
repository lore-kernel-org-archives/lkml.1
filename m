Return-Path: <linux-kernel-owner+w=401wt.eu-S1751409AbZAKFod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbZAKFod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 00:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbZAKFoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 00:44:24 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:63866 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbZAKFoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 00:44:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=n8522u4/Yhpderr/p16NNt0X3uhJcHX47VYyx5OZzH1owdkxJqUF61wvh1B42V5RhS
         /taY77J787QCw8e10JjJPNvuJ9Rh6KMX5svLs1fc2OgSudC9n9dZqP3a2n1Rur4SnzzE
         XO1uaO5C5bDncoyESJkBeH/FJnJv6BAv6AjGs=
Message-ID: <a9cbba340901102144y2682ae1al4018c3613e99cee9@mail.gmail.com>
Date: Sun, 11 Jan 2009 13:44:22 +0800
From: "Cooper Yuan" <cooperyuan@gmail.com>
To: joseluismarchetti@yahoo.com.br
Subject: Re:
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <204164.94418.qm@web34403.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <204164.94418.qm@web34403.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0B5iawM027651

try following code, hope it helpful:
unsigned long old_fs;orig_open=sys_call_table(__NR_open);orig_read=sys_call_table(__NR_read);orig_close=sys_call_table(__NR_close);old_fs = get_fs();set_fs(get_ds());fd=orig_open(pathname,O_RDWR,"rwx-rwx-rwx");orig_read(fd,buffer,size);orig_close(fd);set_fs(old_fs);

On Sun, Jan 11, 2009 at 11:41 AM, Jose Luis Marchetti<joseluismarchetti@yahoo.com.br> wrote:> Hi,>> I would like to open/read/write/close a regular file from my device> driver.> I think it would be possible, but I am confused, the "The Linux Kernel> Module Programming Guide" states that I can not use standard libraries> from within a module, I know the standard library ends up calling> system calls, but which calls should I use to deal with regular> files ?> I am developing a Ethernet driver and the Mac address configuration>> Thanks in advance!>> JosÃ© LuÃ­s Marchetti>>>      Veja quais sÃ£o os assuntos do momento no Yahoo! +Buscados> http://br.maisbuscados.yahoo.com> --> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at  http://vger.kernel.org/majordomo-info.html> Please read the FAQ at  http://www.tux.org/lkml/>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
