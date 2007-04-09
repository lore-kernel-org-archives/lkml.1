Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXDISG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXDISG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 14:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXDISG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 14:06:56 -0400
Received: from web32503.mail.mud.yahoo.com ([68.142.207.213]:35945 "HELO
	web32503.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753317AbXDISGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 14:06:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=nG9KOnQZy9Bms5PS3SrJ4CGvYbKKRB9YduHwk8yKyhkiHNVDAH4jmmD8gTvk+CJl6XBR0R8+ZWDmJxY6QKqk0IBQCxmNqmCPjx1t8FnP6n2hSRVL7x89QNHKoKDHMaVIFxu8YbWpdIz/h0l0fGuy6fY50YPkg2Uyqax0IGIMQYY=;
X-YMail-OSG: YXrkOCgVM1mWxfF85K1MVMXVYl6j_3kDHVYk6X_RdBxK3Ty6IJQ4GYwgt7QlKVYMG6ZHjamqyvClVLwnfty97eAnb84.eEzMxHFcmeaV78CLrwF6uUh1WHLLx3EeRg--
Date: Mon, 9 Apr 2007 11:06:54 -0700 (PDT)
From: Pat <patchu1@yahoo.com>
Subject: Re: Invalid operand: kernel BUG at mm/rmap.c:434! and arch/i386/mm/highmem.c:42!)
To: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704051949280.20591@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <593671.91760.qm@web32503.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Hugh Dickins <hugh@veritas.com> wrote:
> > The app which is kernel panicing is the only
> > application which makes use of the fusedriver. I'd
> > like to confirm my suspicions on the driver. Do
> you
> > have any suggestions on how I could trace the
> kernel
> > panic to that specific driver?
> 
> Indeed, yes, get its source and look to see what
> it's doing
> with PageReserved - or mail it to me privately and
> I'll take
> a look.  But my Google for fusedriver didn't show
> anything,
> and clearly it has nothing to do with the FUSE
> filesystems.
> 
> Hugh
> 


Sorry for the late reply, I was on vacation with the
family for a few days.

fusedriver is a driver for a customized fpga pci card
used in our systems. I'm not sure how open the
manufacturer will be in sending me the source for the
drivers. I'll contact them though to get their input,
specifically on their use of PageReserved. 

Thanks,
Pat


 
____________________________________________________________________________________
Sucker-punch spam with award-winning protection. 
Try the free Yahoo! Mail Beta.
http://advision.webevents.yahoo.com/mailbeta/features_spam.html
