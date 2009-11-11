Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZKKIWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZKKIWC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 03:22:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbZKKIWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 03:22:01 -0500
Received: from outbound-mail-11.bluehost.com ([69.89.18.111]:45655 "HELO
	outbound-mail-11.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757076AbZKKIWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 03:22:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=P9iSqugIryfikv5yw3aArxjrCw0/taXoduv/4f7ROC/AvkepalX5HX4ULS1yGoDQnLWYvCZ1Qz9g4Ve9eVlW1cIA0L/iV0eu2jxtWkkoz+uEwATc8DNcAKWAP7qzlTTL;
Date: Wed, 11 Nov 2009 08:21:59 +0000
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pci_find_parent_resource patch
Message-ID: <20091111082159.2a5b915b@jbarnes-x200>
In-Reply-To: <alpine.LFD.2.01.0911100745580.31845@localhost.localdomain>
References: <4AF875D0.10602@kernel.org>
	<20091110082340.319f1ad3@jbarnes-x200>
	<86802c440911100205i14dcf69i99cb0ef6f76406d1@mail.gmail.com>
	<alpine.LFD.2.01.0911100745580.31845@localhost.localdomain>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 158.43.2.102 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009 07:57:47 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 	/* We can't insert a non-prefetch resource inside a
> prefetchable parent .. */ if (r->flags & IORESOURCE_PREFETCH)
> 		continue;
> 	/* .. but we can put a prefetchable resource inside a
> non-prefetchable one */ if (!best)
> 		best = r;
> 
>    instead. With the comments, it's now six lines instead of two, but
> it's conceptually simpler, and I _could_ have written it as two lines:
> 
> 	if ((res->flags & IORESOURCE_PREFETCH) && !best)
> 		best = r;	/* Approximating prefetchable by
> non-prefetchable */
> 
>    but I thought that was too damn subtle.
> 
> Feel free to use this long explanation as a commit message if you
> want,

Ok, I applied it to my linux-next tree.

Thanks,
Jesse
