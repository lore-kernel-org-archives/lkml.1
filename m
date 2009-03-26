Return-Path: <linux-kernel-owner+w=401wt.eu-S1754414AbZCZD6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414AbZCZD6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753476AbZCZD56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:57:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59720
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbZCZD55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:57:57 -0400
Date: Wed, 25 Mar 2009 20:57:45 -0700 (PDT)
Message-Id: <20090325.205745.208859329.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: kyle@moffetthome.net, jeff@garzik.org, mjg59@srcf.ucam.org, tytso@mit.edu,
       hch@infradead.org, jack@suse.cz, akpm@linux-foundation.org,
       mingo@elte.hu, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       a.p.zijlstra@chello.nl, npiggin@suse.de, jens.axboe@oracle.com,
       drees76@gmail.com, jesper@krogh.cc, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.29
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0903252017100.3032@localhost.localdomain>
References: <49CAEDA7.1080902@garzik.org>
	<f73f7ab80903252003j248b416ewe52b613c5b53066c@mail.gmail.com>
	<alpine.LFD.2.00.0903252017100.3032@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 Mar 2009 20:40:23 -0700 (PDT)

> For example, the latest one came from git actually checking the error code 
> from 'close()'. Tell me the last time you saw anybody do that in a real 
> program. Hint: it's just not done. EVER.

Emacs does it too, and I know that you consider GNU emacs to be the
definition of abnormal :-)

That's how we found some misbehaviors in NFS a while ago, we used to
return -EAGAIN or something like that from close() on NFS files.  This
was like 12 years ago and it gave emacs massive heartburn.
