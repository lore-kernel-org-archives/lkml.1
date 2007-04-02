Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbXDBJMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbXDBJMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 05:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965148AbXDBJMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 05:12:37 -0400
Received: from post.fh-kl.de ([143.93.17.200]:59552 "EHLO post.fh-kl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933190AbXDBJMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 05:12:36 -0400
X-Greylist: delayed 1562 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Apr 2007 05:12:36 EDT
From: Wilhelm Meier <wilhelm.meier@fh-kl.de>
Organization: University of applied sciences Kaiserslautern / Germany
To: linux-cifs-client@lists.samba.org
Subject: Re: [linux-cifs-client] Re: cifs and kthread_run / kernel_thread
Date: Mon, 2 Apr 2007 10:58:36 +0200
User-Agent: KMail/1.9.6
Cc: "Q (Igor Mammedov)" <qwerty0987654321@mail.ru>,
       "Steve French (smfltc)" <smfltc@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <20070331120030.BE6A916387F@lists.samba.org> <46100407.30403@us.ibm.com> <4610B80F.9020102@mail.ru>
In-Reply-To: <4610B80F.9020102@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704021058.37987.wilhelm.meier@fh-kl.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve, hi Igor,

Am Montag, 2. April 2007 schrieb Q (Igor Mammedov):
> >
> > No - IIRC the original patch (for the switch of cifs from kernel_thread
> > to kthread) had a
> > minor implementation problem in handling the cifs_demultiplex thread, so
> > this one small
> > area was left with the old style.

can you remember what the problems (if any) were with this patch from Igor?

>
> It seems to me that I rewrote cifs_demultiplex_thread to use kthread_run
> in DFS patch.

o.k., I found the patch on the list. Will do some testing with it.

-
Wilhelm
