Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbXIULhn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbXIULhn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 07:37:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbXIULhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 07:37:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:63273 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276AbXIULhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 07:37:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FZ5R6f0/lCaEyT44k9x+CZwyhFAjMxas7m2dArC3JSLLn/b48HD39OIqv8nQbMXk7mgJKHXej1vTNWGbx/t9gobfCevBWoWhpj+dVe/kKZPTBFa4qsTbh7I69dw1nApqDuvrTyICyUuTEGeoVVd+3yPWYXouTINa+vPMWrKsaNI=
Message-ID: <fbe8b1780709210437s18b24945jab5a3ffa07646427@mail.gmail.com>
Date: Fri, 21 Sep 2007 13:37:33 +0200
From: "Peter Stahlir" <peter.stahlir@googlemail.com>
To: "Muhammad Tayyab" <mail.tayyab@gmail.com>
Subject: Re: Git as a filesystem
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46F3AAC1.5050409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fbe8b1780709210348n1b1bd739rf5bfe0a73381b3ec@mail.gmail.com>
	 <46F3AAC1.5050409@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Peter Stahlir wrote:
> > Hi!
> >
> > Is it possible/feasible to use git as a filesystem?
> > Like having git on top of ext3.
> >
> > This way I could do a gitfs-gc and there is only one
> > pack file sitting on the disk which is a compressed
> > version of the whole system.
> > I am not interested in a version controlled filesystem,
> > only in the space saving aspects.


2007/9/21, Muhammad Tayyab <mail.tayyab@gmail.com>:
> Hi,
>    I think it would be a bad idea to use Git as a part of filesystem. If
> someone wants to install it and use it, its his choice, but if we make
> it the part of Filesystem, and just use it for compression, this will
> reduce the performance.
>    For compression, i think more preferable is to make a patch for ext3
> that implements the compression, like compression patch for ext2.

As I understand it the compression patches for ext2 only compress
a single file. I think gitfs would compress much better because it
deltifies between all files. So if you are not interested in
performance but space
efficiency a gitfs would be nice.

Peter

P.S.: I was told that there exists a fuse based gitfs at
http://www.sfgoth.com/~mitch/linux/gitfs/
But I think our goals differ.

files.
