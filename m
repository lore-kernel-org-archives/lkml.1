Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbXHIVxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbXHIVxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 17:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbXHIVxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 17:53:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbXHIVxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 17:53:36 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RFC PATCH 1/4] pass open file to ->setattr()
To: Miklos Szeredi <miklos@szeredi.hu>, bfields@fieldses.org,
       miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ftp.linux.org.uk, hch@infradead.org
Reply-To: 7eggert@gmx.de
Date: Thu, 09 Aug 2007 23:52:49 +0200
References: <8Qihj-74G-7@gated-at.bofh.it> <8Qihm-74G-29@gated-at.bofh.it> <8Qihm-74G-27@gated-at.bofh.it> <8Qir2-7gx-25@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IJFw1-0000j1-FX@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18vMiOYzbYo510VyJ/CAvBvS5eYBiRia4LSQYU
 OM7HTOhSRrzU8GwHinkeftIAO/IIcqk//Injm9YekUxruc/pPn
 4whtH0pn4V76xCdTw2q/A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

>> > This is needed to be able to correctly implement open-unlink-fsetattr
>> > semantics in some filesystem such as sshfs, without having to resort
>> > to "silly-renaming".
>> 
>> How do you plan to do that?
> 
> Easy: the SFTP protocol has stateful opens and defines an FSTAT call.

Is it possible to reconnect without umounting? If yes, the unlinked files
would be lost in spite of being opened, wouldn't they?
-- 
Top 100 things you don't want the sysadmin to say:
11. Can you get VMS for this Sparc thingy?

Friﬂ, Spammer: ssbuv@whUG.7eggert.dyndns.org w1tM9GC@a.7eggert.dyndns.org
