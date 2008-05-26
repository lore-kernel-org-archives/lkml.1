Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYEZOPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYEZOPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYEZOPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:15:43 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:43682 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbYEZOPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:15:42 -0400
Date: Mon, 26 May 2008 16:15:41 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Fausto Richetti Blanco <fausto.blanco@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com
Subject: Re: Pipe buffers' limit of 16 * 4K
In-Reply-To: <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0805261612500.19084@fbirervta.pbzchgretzou.qr>
References: <d8d698ae0805231255i4d0da724p68cb2b9376134797@mail.gmail.com> <d8d698ae0805231719g4202edf2k947bba4128385ab6@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 2008-05-24 02:19, Fausto Richetti Blanco wrote:
>
>       I'm working with a 2.6.9 kernel (ok, I know it's quite old) and
>faced a problem with the 4K (one page) buffer limit for the pipes.
>I've found that in the 2.6.11 the pipes' buffers were changed to a
>circular list of pages which increased this limit to 16 * 4K. This
>limit is hardcoded here /usr/src/linux/include/linux/pipe_fs_i.h:6
>#define PIPE_BUFFERS (16)
>
>       Is there a reason for this not to be an adjustable parameter
>(eg.: by an ulimit in the userspace) ?

Jens had patches to adjust the pipe buffer sizes dynamically via an 
ioctl, perhaps these should really be pushed? I also had interest in 
having these in the kernel for toying with minibuffer audio processing.

