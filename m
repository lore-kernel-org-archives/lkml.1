Return-Path: <linux-kernel-owner+w=401wt.eu-S1753598AbZFEVPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598AbZFEVPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZFEVPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:15:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47954 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbZFEVPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:15:33 -0400
Message-ID: <4A298AF0.3060106@garzik.org>
Date: Fri, 05 Jun 2009 17:15:28 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20090605184608.GA29250@havoc.gtf.org> <20090605211647.2f118a5c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090605211647.2f118a5c@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Missing
>     libata: Use IGN_SIMPLEX for ALi
> which you said you'd kick upstream and without which lots of ALi users
> now get no DMA on half their devices due to PM changes.

It was in linux-next -- promoted to upstream-fixes.


Linus, please pull from this NEW BRANCH

Please pull from 'upstream-linus2' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git 
upstream-linus2

which is upstream-linus + the following commit:

> commit a3cb900cc408977a11519bc7c760f3e499079589
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Wed May 13 15:02:27 2009 +0100
> 
>     [libata] pata_ali: Use IGN_SIMPLEX
>     
>     Some ALi devices report simplex if they have been disabled and re-enabled, a
>     restoring the byte does not work. Ignore it - the needed supporting logic is
>     already present for the SATA ULi ports.
>     
>     Signed-off-by: Alan Cox <alan@linux.intel.com>
>     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
