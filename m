Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXCMQIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXCMQIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933338AbXCMQIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:08:04 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49443 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933326AbXCMQID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:08:03 -0400
Date: Tue, 13 Mar 2007 09:07:09 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@muc.de>, Zachary Amsden <zach@vmware.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>, Dan Hecht <dhecht@vmware.com>,
       Dan Arai <arai@vmware.com>, Andrew Morton <akpm@osdl.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 2/9] Sched clock paravirt op fix.patch
Message-ID: <20070313160709.GH10574@sequoia.sous-sol.org>
References: <200703020254.l222sOaM009656@zach-dev.vmware.com> <20070313140129.GB92373@muc.de> <45F6C2A3.4040305@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6C2A3.4040305@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> In other words, regardless of whether this particular pv_op lives or
> dies, we're going to need to have to deal with stolen time properly.  I
> think this hook is reasonable and useful step towards doing that.

Exactly.  Normal interrupts we can handle.  Having CPU completely
disappear for unkown time periods we can't, and will need to.

thanks,
-chris
