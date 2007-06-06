Return-Path: <linux-kernel-owner+w=401wt.eu-S965907AbXFFXIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965907AbXFFXIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965534AbXFFXIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:08:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59426
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965368AbXFFXIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:08:02 -0400
Date: Wed, 06 Jun 2007 16:08:17 -0700 (PDT)
Message-Id: <20070606.160817.70217859.davem@davemloft.net>
To: davidel@xmailserver.org
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       drepper@redhat.com, mingo@elte.hu, dada1@cosmosbay.com
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
	<20070606235906.72439d16@the-village.bc.nu>
	<Pine.LNX.4.64.0706061558550.10383@alien.or.mcafeemobile.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>
Date: Wed, 6 Jun 2007 16:04:40 -0700 (PDT)

> On Wed, 6 Jun 2007, Alan Cox wrote:
> 
> > > The sys_accept() system call has been modified to return a file
> > > descriptor inside the non-sequential area, if the listening fd is.
> > > The sys_socketcall() system call has been also changed to support
> > > a new SYS_SOCKET2 indentifier.
> > 
> > This still all seems really really ugly. Is there anything wrong with
> > throwing all these extra cases out and replacing the entire lot with
> > 
> > 	prctl(PR_SPARSEFD, 1);
> > 
> > to turn on sparse fd allocation for a process ?
> 
> There was a little discussion where I tried to whisper something similar, 
> but Linus and Uli shot me :) - with good reasons IMO.
> You may link to runtimes that are not non-sequentialfd aware, and will 
> break them.

Thanks for explaining this issue clearly instead of telling people
to "go read the archives" in a condescending manner like someone
else did.
