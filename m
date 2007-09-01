Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbXICTMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbXICTMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 15:12:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbXICTM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 15:12:28 -0400
Received: from ozlabs.org ([203.10.76.45]:34467 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbXICTM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 15:12:27 -0400
Subject: Re: [Lguest] [RFC] 9p Virtualization Transports
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net,
       v9fs-developer@lists.sourceforge.net, lguest@ozlabs.org
In-Reply-To: <11883271601857-git-send-email-ericvh@gmail.com>
References: <11883271601857-git-send-email-ericvh@gmail.com>
Content-Type: text/plain
Date: Sun, 02 Sep 2007 07:14:57 +1000
Message-Id: <1188681297.10802.38.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 13:52 -0500, Eric Van Hensbergen wrote:
> The lguest and kvm transports are functional, but we are still working out
> remaining bugs and need to spend some time focusing on performance issues.
> I wanted to send out this "preview" patch set to the community to solicit
> ideas on things we can do differently/better.

Hi Eric,

	Patches look reasonable, but just a heads-up: lguest will be moving to
virtio, as will kvm.  That means a single implementation for both
(yay!), but it does complicate your life in the short term 8(

	Dor has published a kvm virtio implementation, and we've already
discussed a couple of modifications.  I expect that to be nailed in the
next 2 weeks tho, and lguest will follow.

Thanks!
Rusty.

