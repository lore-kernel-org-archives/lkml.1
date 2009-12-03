Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbZLCLdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbZLCLdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 06:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZLCLdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 06:33:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:30712 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688AbZLCLdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 06:33:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,334,1257148800"; 
   d="scan'208";a="472518145"
Date: Thu, 3 Dec 2009 11:13:29 +0000
From: Alan Cox <alan@linux.intel.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Greg Kroah-Hartman <gregkh@suse.de>, Joe Peterson <joe@skyrush.com>
Subject: Re: [Patch] tty: move a definition out of switch block
Message-ID: <20091203111329.3558ea39@linux.intel.com>
In-Reply-To: <4B177878.2090002@redhat.com>
References: <20091201075744.4456.48125.sendpatchset@localhost.localdomain>
	<20091201154412.4002a0d8@linux.intel.com>
	<4B177878.2090002@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> jumps to its first label at a first glance. I know in this case
> the code is _not_ wrong, but again, it's not good for reading.

So this is just your personal preference ? That seems like pointless
churn, especially given that many other people consider putting the
variables there is better than

	case foo:
	{
		Blah blah
	}
	}
}

in switches
