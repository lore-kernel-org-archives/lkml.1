Return-Path: <linux-kernel-owner+w=401wt.eu-S1761466AbXJMHxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761466AbXJMHxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbXJMHxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:53:25 -0400
Received: from hpsmtp-eml12.kpnxchange.com ([213.75.38.112]:32790 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbXJMHxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:53:24 -0400
From: Frans Pop <elendil@planet.nl>
To: Greg KH <greg@kroah.com>
Subject: Re: [stable] 2.6.23 regression: top displaying 9999% CPU usage
Date: Sat, 13 Oct 2007 09:53:21 +0200
User-Agent: KMail/1.9.7
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
References: <200710122231.50739.elendil@planet.nl> <20071012212223.GD16418@kroah.com>
In-Reply-To: <20071012212223.GD16418@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710130953.22099.elendil@planet.nl>
X-OriginalArrivalTime: 13 Oct 2007 07:53:22.0439 (UTC) FILETIME=[20970170:01C80D6E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 October 2007, Greg KH wrote:
> On Fri, Oct 12, 2007 at 10:31:50PM +0200, Frans Pop wrote:
> > Please consider this patch for 2.6.23.2
> > http://lkml.org/lkml/2007/10/4/389
> >
> > tested by me in
> > http://lkml.org/lkml/2007/10/5/150
> >
> > to fix the regression first reported in
> > http://lkml.org/lkml/2007/10/3/123
> >
> > Cause of the wrong display in top is the value of stime in
> > /proc/<pid>/stat decreasing occasionally.
> >
> > The issue is also registered as:
> > http://bugzilla.kernel.org/show_bug.cgi?id=9135
>
> Is it already in Linus's tree?  If so, do you have a git commit id?  If
> not, please let us (stable@) know when it is, and what the id is, and
> then we can add it to our tree.

Not AFAICT.
CCing Christian (as patch author) and Ingo (as author of the change that 
caused the regression) so they can push it through the correct channels.
