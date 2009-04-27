Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbZD0OWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbZD0OWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 10:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZD0OWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 10:22:24 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:38499 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbZD0OWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 10:22:24 -0400
Date: Mon, 27 Apr 2009 10:12:26 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Vivek Kashyap <vivk@us.ibm.com>, Mel Gorman <mel@linux.vnet.ibm.com>,
       Robert MacFarlan <Robert_MacFarlan@us.ibm.com>,
       "Fu, Michael" <michael.fu@intel.com>
Subject: Re: Large Pages - Linux Foundation HPC
In-Reply-To: <1240728861.29485.41.camel@nimitz>
Message-ID: <alpine.DEB.1.10.0904271010300.1474@qirst.com>
References: <1240331533.32731.2.camel@badari-desktop>  <1240333025.32604.392.camel@nimitz>  <20090421182555.GA8977@balbir.in.ibm.com>  <20090425084804.GA517@localhost> <1240728861.29485.41.camel@nimitz>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009, Dave Hansen wrote:

> On Sat, 2009-04-25 at 16:48 +0800, Wu Fengguang wrote:
> > Based on Dave's descriptions that HPC apps typically
> > - do mlock(), to pre-populate memory and pin them in memory
> > - run at fresh boot, with loads of high order pages available
>
> There are definitely some of them that do this, but it certainly isn't
> all.  It may not even be the norm.

Some of the machine have so much memory available that 2M allocations are
likely to succeed. If a machine has a couple of terabytes of memory
available then its highly unlikely that a 2M allocation will not succeed.

