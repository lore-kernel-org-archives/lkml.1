Return-Path: <linux-kernel-owner+w=401wt.eu-S1751695AbXC1NlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbXC1NlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 09:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbXC1NlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 09:41:02 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55424 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751695AbXC1NlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 09:41:00 -0400
Date: Wed, 28 Mar 2007 15:44:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Stuart MacDonald" <stuartm@connecttech.com>
Cc: "'Oliver Neukum'" <oliver@neukum.org>, <linux-kernel@vger.kernel.org>
Subject: Re: question on tty open and close
Message-ID: <20070328154439.40ca5c3c@the-village.bc.nu>
In-Reply-To: <019201c7713c$1a3277c0$294b82ce@stuartm>
References: <200703281516.31366.oliver@neukum.org>
	<019201c7713c$1a3277c0$294b82ce@stuartm>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > So we have a file that's closed although open() never succeeded?
> > > 
> > > That's correct! It's been a pain in my butt for years.
> > 
> > How did you deal with that proctological issue?
> 
> Just make sure the close() handles the situation properly. It makes
> reference counting...  fun.
> 
> The serial driver has always handled it like this.

I'm also not aware of any reason other than history, which means if
someone cares to double check the other drivers there really shouldn't be
an obstacle to "fixing" this behaviour.

Unless anyone knows different ?

Alan
