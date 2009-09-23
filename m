Return-Path: <linux-kernel-owner+w=401wt.eu-S1752610AbZIWPwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbZIWPwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZIWPwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:52:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZIWPv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:51:59 -0400
Subject: Re: fanotify as syscalls
From: Eric Paris <eparis@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Jamie Lokier <jamie@shareable.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>, David Miller <davem@davemloft.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "alan@linux.intel.com" <alan@linux.intel.com>,
       "hch@infradead.org" <hch@infradead.org>
In-Reply-To: <20090923133232.5577688d@infradead.org>
References: <20090912094110.GB24709@ioremap.net>
	 <200909221731.34717.agruen@suse.de>
	 <alpine.DEB.2.00.0909220836200.10460@makko.or.mcafeemobile.com>
	 <200909230939.34003.tvrtko.ursulin@sophos.com>
	 <20090923133232.5577688d@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Sep 2009 11:51:37 -0400
Message-Id: <1253721097.2890.3.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 13:32 +0200, Arjan van de Ven wrote:
> On Wed, 23 Sep 2009 09:39:33 +0100
> Tvrtko Ursulin <tvrtko.ursulin@sophos.com> wrote:
> 
> > Lived with it because there was no other option. We used LSM while it
> > was available for modules but then it was taken away. 
> 
> ... at which point you could have submitted your LSM module for
> inclusion... you'd be the first (and only?) Anti Virus vendor that
> would be in the mainline kernel.. speaking of competitive advantage,
> coming out of the box in all distributions.

And users would be left in a situation between choosing an LSM which
actually does in provable ways increase security and using an AV
scanner.  Until magic solves the LSM stacking problem (it's been tried,
no magic) I don't think any distro wants AV vendors as LSMs.

-Eric

