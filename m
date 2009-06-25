Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbZFYQts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbZFYQts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZFYQtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:49:39 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:53476 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbZFYQti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:49:38 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 25 Jun 2009 09:44:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Gregory Haskins <ghaskins@novell.com>
cc: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mst@redhat.com, avi@redhat.com, paulmck@linux.vnet.ibm.com,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [KVM PATCH v5 0/4] irqfd fixes and enhancements
In-Reply-To: <4A4382AE.8000508@novell.com>
Message-ID: <alpine.DEB.1.10.0906250942070.9517@makko.or.mcafeemobile.com>
References: <20090625132441.26748.641.stgit@dev.haskins.net> <4A4382AE.8000508@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jun 2009, Gregory Haskins wrote:

> So I know we talked yesterday in the review session about whether it was
> actually worth all this complexity to deal with the POLLHUP or if we
> should just revert to the prior "two syscall" model and be done with
> it.  Rusty reflected these same sentiments this morning in response to
> Davide's patch in a different thread.
> 
> I am a bit torn myself, tbh.  I do feel as though I have a good handle
> on the issue and that it is indeed now fixed (at least, if this series
> is applied and the slow-work issue is fixed, still pending upstream
> ACK).  I have a lot invested in going the POLLHUP direction having spent
> so much time thinking about the problem and working on the patches, so I
> a bit of a biased opinion, I know.
> 
> The reason why I am pushing this series out now is at least partly so we
> can tie up these loose ends.  We have both solutions in front of us and
> can make a decision either way.  At least the solution is formally
> documented in the internet archives forever this way ;)
> 
> I took the review comments to heart that the shutdown code was
> substantially larger and more complex than the actual fast-path code.  I
> went though last night and simplified and clarified it.  I think the
> latest result is leaner and clearer, so please give it another review
> (particularly for races) before dismissing it.
> 
> Ultimately, I think the concept of a release notification for eventfd is
> a good thing for all eventfd users, so I don't think this thing should
> go away per se even if irqfd decides to not use it. 

Whatever you guys decide if fine for me. Next time though, I think I'll 
wait a month or so after taking any action :)


- Davide


