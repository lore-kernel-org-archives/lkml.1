Return-Path: <linux-kernel-owner+w=401wt.eu-S968355AbXEHQVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968355AbXEHQVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968313AbXEHQVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:21:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:58584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968189AbXEHQVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:21:37 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Long file names in VFAT broken with iocharset=utf8
To: Albert Cahalan <acahalan@gmail.com>, arvidjaar@mail.ru,
       hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Reply-To: 7eggert@gmx.de
Date: Tue, 08 May 2007 18:21:18 +0200
References: <8ipOe-5KI-3@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1HlSRC-0000cg-Je@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18OK+Z+TN4SJMDI1+2P9YVa22Cb5kTg4dOeJNA
 Ix6q/74jSfl+suJkNQVIoVkFrJpxdovITG4HcnrTfhgmCh1yVN
 ny99MZVcwKEIZhunNTcEw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Albert Cahalan <acahalan@gmail.com> wrote:

[...]
> At two bytes per character, you get 127 characters in a filename.
> That's wider than the standard 80-column display, and far wider
> than the 28 or 29 characters that an "ls -l" has room for. In a
> GUI file manager or file dialog box, you'll have to scroll sideways.
> In a web browser directory listing, you'll almost certainly have
> to scroll sideways. Must of this even applies to Windows tools.
> 
> In other words, this is user error. Somebody thought that a filename
> was a place to store a document, probably a README file. What next,
> shall we MIME-encode an icon into the filename?

I've got a music file where the artist name is 113 characters long, if I use
an abbreviation.

> Fix: the vfat driver should use the 8.3 name for such files.

Let's port that to ext3! I wantet the system to rename my files into
abcd~123.ext for all my life! NOT!
-- 
If at first you don't succeed call in an air-strike. 

Friﬂ, Spammer: fMxJx@egfX.7eggert.dyndns.org qexHpj@zRuKa.7eggert.dyndns.org
 e@fjsuTc.7eggert.dyndns.org Q-Bms1F@Wa.7eggert.dyndns.org
