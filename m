Return-Path: <linux-kernel-owner+w=401wt.eu-S1753582AbXFCXcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582AbXFCXcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 19:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXFCXcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 19:32:07 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1328 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbXFCXcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 19:32:04 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 3 Jun 2007 16:32:00 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 2/2] ufd v1 - use unsequential O(1) fdmap
In-Reply-To: <46634A2A.9060208@redhat.com>
Message-ID: <Pine.LNX.4.64.0706031631110.13247@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825146.2>
 <4663067C.9050002@redhat.com> <Pine.LNX.4.64.0706031127220.13247@alien.or.mcafeemobile.com>
 <466319DB.80800@redhat.com> <Pine.LNX.4.64.0706031311490.13247@alien.or.mcafeemobile.com>
 <4663289D.5030109@redhat.com> <Pine.LNX.4.64.0706031601150.13247@alien.or.mcafeemobile.com>
 <46634A2A.9060208@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Davide Libenzi wrote:
> > Randomizing the base is not a problem. Should this be always, or flag 
> > driven?
> 
> I would say all the time.  I don't think it's a problem with
> reproducibility in any reasonable code.

Agreed. That makes code simpler too.



- Davide


