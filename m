Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab0BOPqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:46:25 -0500
Received: from stinky.trash.net ([213.144.137.162]:63326 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0BOPqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:46:23 -0500
Message-ID: <4B796C4B.50700@trash.net>
Date: Mon, 15 Feb 2010 16:46:19 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Sridhar Samudrala <sri@us.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tun: socket filter support
References: <cover.1266144917.git.mst@redhat.com> <20100214110110.GC30182@redhat.com> <4B79673B.7050908@trash.net> <201002151645.01410.arnd@arndb.de>
In-Reply-To: <201002151645.01410.arnd@arndb.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Monday 15 February 2010, Patrick McHardy wrote:
>> I'm not sure how the tun socket is exposed, but won't the regular
>> SO_ATTACH_FILTER/SO_DETACH_FILTER setsockopts already work for
>> tun sockets?
> 
> The tun socket is not exposed at all, it's an implementation detail
> of the tun/tap driver, which only has a chardev interface with
> ioctl methods.

I see, thanks for the explanation.
