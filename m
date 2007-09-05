Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbXIERt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbXIERt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbXIERte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:49:34 -0400
Received: from ozlabs.org ([203.10.76.45]:55630 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758011AbXIERtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:49:33 -0400
Subject: Re: [PATCH] Fix preemptible lazy mode bug
From: Rusty Russell <rusty@rustcorp.com.au>
To: Zachary Amsden <zach@vmware.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andi Kleen <ak@suse.de>, Anthony Liguori <anthony@codemonkey.ws>
In-Reply-To: <1189011909.21516.1.camel@bodhitayantram.eng.vmware.com>
References: <46CE70C8.2030005@vmware.com> <46CE8069.9070404@goop.org>
	 <46CE81DC.90103@vmware.com>  <46D9D517.6010201@goop.org>
	 <1188850468.10802.66.camel@localhost.localdomain>
	 <46DD60A9.8080203@goop.org>
	 <1189010022.10802.161.camel@localhost.localdomain>
	 <1189011909.21516.1.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 03:48:59 +1000
Message-Id: <1189014539.10802.177.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 10:05 -0700, Zachary Amsden wrote:
> On Thu, 2007-09-06 at 02:33 +1000, Rusty Russell wrote:

> > +	BUG_ON(get_lazy_mode() && !(mode == PARAVIRT_LAZY_NONE |
> > +				    | mode == PARAVIRT_LAZY_FLUSH));
> 
> That's a pretty strange line break.

Sorry, should have mentioned it's completely untested: too far from my
test machine 8(

Thanks,
Rusty.

