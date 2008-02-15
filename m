Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbYBOSZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbYBOSZW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYBOSYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:24:53 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60712 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbYBOSYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:24:53 -0500
To: auke-jan.h.kok@intel.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-reply-to: <47B5D6EB.5010203@intel.com> (auke-jan.h.kok@intel.com)
Subject: Re: 2.6.24-mm1 bugs
References: <E1JPyyn-00055D-2i@pomaz-ex.szeredi.hu> <47B5BDC0.3020003@intel.com> <E1JQ3cu-0005ZW-7k@pomaz-ex.szeredi.hu> <47B5C38A.5000909@intel.com> <E1JQ4ik-0005iq-NH@pomaz-ex.szeredi.hu> <47B5D6EB.5010203@intel.com>
Message-Id: <E1JQ5Er-0005p7-HD@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 15 Feb 2008 19:24:45 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> the register dump looks OK as far as I can see. Since initialization
> works OK and the adapter seems to be setup OK reading from the
> register dump, I'm not sure at all what is going on.
> 
> can you try manually ifup-ing the device and running tcpdump? do you
> see packets coming in?

Well it does seem to receive the DHCP reply.

> 
> just for kicks, have you tried a different cable? or is the adapter
> consistently working properly using a different kernel/driver?

It has been consistently working properly for a long time with various
kernels (and the e1000 driver).  I've now swithed to 2.6.24-mm1 and
e1000e, and it's almost consistently broken after boot and resume, and
sometimes needs several tries (with the KDE NetworkManager thingy) to
make it work.

My guess is that either NetworkManager is buggy, or there's something
else in -mm that's breaking NetworkManager.  But now it does seem
unlikely to be an ethernet driver issue.

Thanks,
Miklos
