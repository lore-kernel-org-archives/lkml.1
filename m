Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZHTQ2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZHTQ2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 12:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbZHTQ2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 12:28:39 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:59564 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZHTQ2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 12:28:38 -0400
X-Greylist: delayed 486 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2009 12:28:38 EDT
X-AuthUser: davidel@xmailserver.org
Date: Thu, 20 Aug 2009 09:20:31 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: avi@redhat.com, gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
In-Reply-To: <20090820155655.GA8764@redhat.com>
Message-ID: <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com>
References: <20090820155655.GA8764@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009, Michael S. Tsirkin wrote:

> Davide,
> Looks like I got an ack from Avi and no comments from others,
> so the following patchset is identical to the last RFC.
> Can it be merged for 2.6.32?
> Thanks!

I briefly looked at this while in vacation, although I did not reply 
hoping the horrible feeling about this code would go away.
It didn't.
I find this to be an ugly and ad-hoc multiplexing of eventfd with added 
functionalities of questionable general use.
I'm pretty sure you can do better on KVM side, to solve the problem w/out 
littering eventfd.


- Davide

