Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZCDWRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZCDWRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 17:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZCDWQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 17:16:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38053 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbZCDWQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 17:16:48 -0500
Date: Wed, 4 Mar 2009 14:16:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cedric Roux <sed@free.fr>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       mtk.manpages@gmail.com, linux-api@vger.kernel.org
Subject: Re: [PATCH] [retry] vt: add ioctl commands to /dev/vcsaN to get/put
 the current palette of the given tty
Message-Id: <20090304141635.fa756831.akpm@linux-foundation.org>
In-Reply-To: <427911.793301236157128303.JavaMail.root@spooler2-g27.priv.proxad.net>
References: <427911.793301236157128303.JavaMail.root@spooler2-g27.priv.proxad.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009 09:58:48 +0100 (CET)
Cedric Roux <sed@free.fr> wrote:

> From: Cedric Roux <sed@free.fr>
> 
> A ioctl interface and two ioctl commands added to /dev/vcsaN
> to get/put the current palette of the given tty.
> 
> ...
>
> - lock_kernel() is called. Maybe it's not necessary? I'm not
>   confident enough. You decide.

I wouldn't have a clue what it's protecting in there.  But it seems
sane to put it in - once someone gets down and de-lock_kernel()s that
code, they can work out what it should be replaced by.

