Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbZI1Ut0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbZI1Ut0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbZI1Ut0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:49:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56954 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZI1UtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:49:25 -0400
Date: Mon, 28 Sep 2009 22:49:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Message-ID: <20090928204923.GA1960@elf.ucw.cz>
References: <aday6omhz9d.fsf@cisco.com> <20090915113434.GF1328@ucw.cz> <ada7hw0gsqz.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ada7hw0gsqz.fsf@cisco.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-09-15 07:57:56, Roland Dreier wrote:
> 
>  > I don't remember seeing discussion of this on lkml. Yes it  is in
>  > -next...
> 
> eg http://lkml.org/lkml/2009/7/31/197 and followups, or search for v2
> and earlier patches.

Well... it seems little overspecialized. Just modifying libc to
provide hooks you want looks like better solution.

>  > Basically it allows app to 'trace itself'? ...with interesting mmap()
>  > interface, exporting int to userspace, hoping it behaves atomically...? 
> 
> Yes, it allows app to trace what the kernel does to memory mappings.  I
> don't believe there's any real issue to atomicity of mmap'ed memory,
> since userspace really just tests whether read value is == to old read
> value or not.

That still needs memory barriers etc.. to ensure reliable operation,
no?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
