Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbZCISwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbZCISwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZCISvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:51:24 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:10521 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527AbZCISvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:51:20 -0400
Date: Mon, 9 Mar 2009 12:51:17 -0600
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org
Cc: xyzzy@speakeasy.org, djwong@us.ibm.com, shimada-yxb@necst.nec.co.jp,
       rjw@sisk.pl, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/11] PCI core learns hotplug
Message-ID: <20090309185117.GJ32589@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
	xyzzy@speakeasy.org, djwong@us.ibm.com, shimada-yxb@necst.nec.co.jp,
	rjw@sisk.pl, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20090309052933.3918.86601.stgit@bob.kio>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309052933.3918.86601.stgit@bob.kio>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alex Chiang <achiang@hp.com>:
> 
> There is still one major bug somewhere that shows up only when using
> the PCIe portdriver (that is, any time PCIe support is built into
> the kernel). You get an oops during multiple remove/rescan cycles,
> especially on devices with an internal bridge.

Got it, we had a double-free in the PCIe port driver which was
causing all sorts of problems.

I fixed that and now this patch series is stable enough for
others to actually apply and test. As of now, there are no known
bugs.

Of course, I'm going to keep testing and try to find some more
bugs. :)

As a reminder, if you want to play with this series, you'll also
need these two patches:

> 	http://thread.gmane.org/gmane.linux.kernel.pci/3437
> 	http://lkml.org/lkml/2009/3/7/173

And now this third patch:

	http://thread.gmane.org/gmane.linux.kernel.pci/3524

Finally, patch 07/11 needs to be updated. I'll post a reply to
that mail with the updated patch.

Thanks.

/ac

