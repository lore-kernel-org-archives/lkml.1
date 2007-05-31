Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbXEaJDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbXEaJDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755089AbXEaJDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:03:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36782
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753374AbXEaJDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:03:10 -0400
Date: Thu, 31 May 2007 02:03:24 -0700 (PDT)
Message-Id: <20070531.020324.35020300.davem@davemloft.net>
To: stefanr@s5r6.in-berlin.de
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [RFC 1/4] CONFIG_STABLE: Define it
From: David Miller <davem@davemloft.net>
In-Reply-To: <465E8D4C.9040506@s5r6.in-berlin.de>
References: <20070531002047.702473071@sgi.com>
	<20070531003012.302019683@sgi.com>
	<465E8D4C.9040506@s5r6.in-berlin.de>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Date: Thu, 31 May 2007 10:54:36 +0200

> b) Of course nobody wants STABLE=n. :-)  How about:
> 
> config RELEASE
> 	bool "Build for release"
> 	help
> 	  If the kernel is declared as a release build here, then
> 	  various checks that are only of interest to kernel development
> 	  will be omitted.

Agreed :-)

> 
> c) A drawback of this general option is, it's hard to tell what will be
>    omitted in particular.

In that sense it is similar to EMBEDDED, but I still think there
is high value to this, I can already think of several things I
want to put under this which are only noise I want to see during
development periods.
