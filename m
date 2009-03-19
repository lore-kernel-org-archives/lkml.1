Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbZCSGxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbZCSGxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 02:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZCSGxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 02:53:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33816
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754592AbZCSGxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 02:53:44 -0400
Date: Wed, 18 Mar 2009 23:53:31 -0700 (PDT)
Message-Id: <20090318.235331.65960278.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crash with /proc/iomem on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0903170807440.25109@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0903170758060.24107@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0903170807440.25109@hs20-bc2-1.build.redhat.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Tue, 17 Mar 2009 08:08:08 -0400 (EDT)

> 
> 
> On Tue, 17 Mar 2009, Mikulas Patocka wrote:
> 
> > Hi
> > 
> > When you compile kernel on Sparc64 with heap memory checking and type
> > "cat /proc/iomem", you get a crash, because pointers in struct resource 
> > are uninitialized.
> > 
> > Most code fills struct resource with zeros, so I assume that it is 
> > responsibility of the caller of request_resource to initialized it, not 
> > the responsibility of request_resource functuion.
> > 
> > After 2.6.29 is out, there could be a check for uninitialized fields added 
> > to request_resource to avoid crashes like this.
> > 
> > Mikulas
> 
> I forgot to add:
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Patch applied and queued up for -stable, thanks a lot.
