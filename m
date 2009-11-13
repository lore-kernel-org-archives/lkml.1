Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZKMLfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZKMLfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 06:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbZKMLfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 06:35:06 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42184 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082AbZKMLfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 06:35:05 -0500
Date: Fri, 13 Nov 2009 12:35:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
       linux-mm@kvack.org, gerald.schaefer@de.ibm.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] Allow memory hotplug and hibernation in the same kernel
Message-ID: <20091113113509.GB30880@basil.fritz.box>
References: <20091113105944.GA16028@basil.fritz.box> <20091113200745.33CE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091113200745.33CE.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 08:13:23PM +0900, KOSAKI Motohiro wrote:
> (cc to goto-san)
> 
> > Allow memory hotplug and hibernation in the same kernel
> > 
> > Memory hotplug and hibernation was excluded in Kconfig. This is obviously
> > a problem for distribution kernels who want to support both in the same
> > image.
> 
> Sure.
> 
> This exclusion is nearly meaningless. if anybody remove cpu, memory and/or
> various peripheral from hibernated machine. the system might not resume.
> it's obvious. memory is not special.


The main motivation for the patch is really just to allow both in the 
same kernel (so the Kconfig change). The actual exclusion is 
not really very interesting as you point out.

Otherwise memory hotadd is not usable in universal kernel that
runs on laptops too.

-Andi
