Return-Path: <linux-kernel-owner+w=401wt.eu-S968507AbXEHWnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968507AbXEHWnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967609AbXEHWnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:43:10 -0400
Received: from smtprelay03.ispgateway.de ([80.67.18.15]:60904 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967171AbXEHWnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:43:09 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: tglx@linutronix.de
Subject: Re: [PATCH 1/2] LogFS proper
Date: Wed, 9 May 2007 00:44:14 +0200
User-Agent: KMail/1.9.6
Cc: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>,
       Andrew Morton <akpm@osdl.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       David Chinner <dgc@sgi.com>
References: <20070507215913.GA15054@lazybastard.org> <20070507220036.GB15054@lazybastard.org> <1178608950.3042.273.camel@localhost.localdomain>
In-Reply-To: <1178608950.3042.273.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705090044.16096.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 May 2007, Thomas Gleixner wrote:
> On Tue, 2007-05-08 at 00:00 +0200, Jörn Engel wrote:
> > +#define packed __attribute__((__packed__))
> 
> Please use the __attribute__((__packed__)) on your structs instead of
> creating some extra "needs lookup" magic.

Don't worry, we have __packed predefined for this. 
Just look in include/linux/compiler-gcc.h

I love it, because I always forget at least one brace or undescore level :-)




Regards

Ingo Oeser
