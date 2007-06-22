Return-Path: <linux-kernel-owner+w=401wt.eu-S1752552AbXFVTbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbXFVTbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbXFVTbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:31:36 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:34863 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXFVTbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:31:36 -0400
Date: Fri, 22 Jun 2007 12:31:24 -0700
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86-64: disable the GART before allocate aperture
Message-ID: <20070622193124.GG5051@rhun.smartcity.com>
References: <200706221219.16243.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706221219.16243.yinghai.lu@sun.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 12:19:15PM -0700, Yinghai Lu wrote:
> [PATCH] x86-64: disable the GART before allocate aperture
> 
> For K8 system: 4G RAM with memory hole remapping enabled, or more
> than 4G RAM installed. when mem is allocated for GART, it will do
> the memset for clear.  and for kexec case, the first kernel already
> enable that, the memset in second kernel will cause the system
> restart. So disable that at first before we try to allocate mem for
> it.

Why does the memset in the second kernel cause a system restart?

Cheers,
Muli
