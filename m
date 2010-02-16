Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0BPIfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:35:45 -0500
Received: from mail-bw0-f213.google.com ([209.85.218.213]:46323 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab0BPIfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:35:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ELINDAK5st0LwopHzQjI4TRl85ZIfp07rdZ7ODQ/zk+SH39SqhRgtQuPRuU6VJ1Q1T
         a9J3hEmzoeSj5RSo7bg0MkZVQFNqdy4PihGLgVOVmVtk6AIwWaogtAn5XC9FwWoFfufz
         R/wUFFg+4yv1pfX3qGzV7sq+fKqDbCiXANOss=
MIME-Version: 1.0
Date: Tue, 16 Feb 2010 10:35:40 +0200
Message-ID: <bec9a5871002160035v63cce8ck9ecb9252b2f162a6@mail.gmail.com>
Subject: Re: Reading /dev/mem by dd
From: Nameer Yarkon <nameer.yarkon@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Andi Kleen <andi@firstfloor.org>, Robert Hancock <hancockrwd@gmail.com>,
       "Anton D. Kachalov" <mouse@mayc.ru>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 12, 2009 at 8:13 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Is that the only valid use of /dev/mem, or even its main use?
>
> These days it is the primary use. Things like X11 were historically
> probably the biggest user of it, and things like LRMI sometimes need that
> sort of stuff.

how does X11 get now direct access to the physical memory (instead of
/dev/mem) ?
