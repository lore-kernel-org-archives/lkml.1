Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbYFQSV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbYFQSV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 14:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756196AbYFQSVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 14:21:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323AbYFQSVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 14:21:48 -0400
Date: Tue, 17 Jun 2008 14:14:27 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       arjan@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       tglx@linutronix.de, linville@tuxdriver.com
Subject: Re: Oops report for the week preceding June 16th, 2008
Message-ID: <20080617181427.GB13192@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
	Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
	arjan@linux.intel.com, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	tglx@linutronix.de, linville@tuxdriver.com
References: <4856AFDF.5080901@linux.intel.com> <20080617092023.GA20621@elte.hu> <20080617.022652.76635616.davem@davemloft.net> <20080617153356.GA3510@elte.hu> <20080617175414.GA9866@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080617175414.GA9866@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 10:54:14AM -0700, Greg KH wrote:

 > We try to respect the authors of the code when not including them into
 > the kernel tree for situations like this :)
 > 
 > As for why Fedora added it, it might be because they can control both
 > sides of the boundry with matching packages much easier.

That's exactly it.  Dave Airlie keeps both the X and kernel side of DRI
in check in Fedora, and with him being the DRI maintainer, he tends to have
a good handle on the state of things.

Nouveau has been a bit bumpy, and isn't ready for mass-use, which is why
we don't enable it by default.  We ship it, but a user has to actually
install it, and set it up to explicitly use it instead of the 'nv' X driver
right now.  Given it's there as a sort of 'preview' for interested parties,
I don't think the world is ending because we jumped the gun by shipping
this even though it's not upstream.

	Dave

-- 
http://www.codemonkey.org.uk
