Return-Path: <linux-kernel-owner+w=401wt.eu-S1761822AbXGEXDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761822AbXGEXDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760071AbXGEXDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:03:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:51580 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759965AbXGEXDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:03:37 -0400
Message-ID: <468D78BE.4030902@garzik.org>
Date: Thu, 05 Jul 2007 19:03:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>, Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
References: <20070703221156.GY14825@petra.dvoda.cz> <20070704084211.GA19128@infradead.org>
In-Reply-To: <20070704084211.GA19128@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Jul 04, 2007 at 12:11:56AM +0200, Karel Zak wrote:
>>  The package build system is now based on autotools. The build system
>>  supports  separate CFLAGS and LDFLAGS for suid programs (SUID_CFLAGS,
>>  SUID_LDFLAGS). For more details see the README file
> 
> And this is really dumb.  autotools is a completely pain in the ass and
> not useful at all for linux-only tools.


A myth.  It is quite useful for packagers, because of the high Just 
Works(tm) factor.  After porting an entire across several revisions of a 
distro, the autotools-based packages are the ones that work out of the 
box 90% of the time.

The other 90% of _my_ time comes from annoying people who roll their own 
Makefile/build solution, which the packager has to then learn.

It's just not scalable for people to keep building their own build 
solutions.

	Jeff


