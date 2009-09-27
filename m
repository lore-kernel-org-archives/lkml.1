Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZI0Lqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZI0Lqq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 07:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbZI0Lqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 07:46:40 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37102 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbZI0Lqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 07:46:36 -0400
Date: Sun, 27 Sep 2009 13:46:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Bernard Pidoux <bernard.pidoux@upmc.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.1 BUG #include <asm/bitsperlong.h>
Message-ID: <20090927114639.GA10311@merkur.ravnborg.org>
References: <4ABF4999.9080206@upmc.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ABF4999.9080206@upmc.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 27, 2009 at 01:16:41PM +0200, Bernard Pidoux wrote:
> The problem is that when I compile an application that never caused any 
> problem before I get an error due to incorrect reference to 
> <asm/bitsperlong>
>
> This was due to int-ll64.h including <asm/bitsperlong.h> which does not exists.
>
> Is the correct solution to replace symbolic link ?
>
> /usr/src/linux/include/asm->asm-x86
>
> by
>
> /usr/src/linux/include/asm->asm-generic

The correct fix is to include the missing bitsperlong in
the asm-x86 directory.
In other words your kernel headers are broken.

Looking at latest kernel we do export bitsperlong.h.
So see if you can find a fix for your broken kernel headers.

	Sam
