Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYF1ED3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYF1ED3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 00:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYF1EDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 00:03:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbYF1EDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 00:03:11 -0400
Date: Fri, 27 Jun 2008 21:02:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: dougthompson@xmission.com, Dave Jiang <djiang@mvista.com>,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/13] EDAC mpc85xx fix pci ofdev
Message-Id: <20080627210218.84b96465.akpm@linux-foundation.org>
In-Reply-To: <468032.24073.qm@web50111.mail.re2.yahoo.com>
References: <20080627155701.72d30927.akpm@linux-foundation.org>
	<468032.24073.qm@web50111.mail.re2.yahoo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 20:53:35 -0700 (PDT) Doug Thompson <norsk5@yahoo.com> wrote:

> 
> --- Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 27 Jun 2008 12:13:13 -0600
> > dougthompson@xmission.com wrote:
> > 
> > > From:	Dave Jiang <djiang@mvista.com>
> > > 
> > > Applied to linux-2.6.26-rc5-mm3
> > > 
> > > Converting PCI err device from platform to open firmware of_dev to comply with
> > > powerpc schemes.
> > 
> > This one doesn't apply due to later changes which should be in 2.6.26-rc8.
> > 
> 
> 
> mmm, doesn't apply to the -mm3?  
> 
> I knew it didn't apply to the 2.6.26-rc5 because there was a patch in the -mm3 which modified the
> same code. I assumed that patch would remain in the -mm tree until 2.6.27, therefore I didn't try
> the -rc8 code base.  
> 
> I applied it 3 times to different 2.6.26-rc5-mm3 trees. The first time there was a problem, but
> did new 2.6.26-rc5 trees with a -mm3 and the last 2 times it worked. That puzzled me.
> 
> interesting.

I suspect there was gregstuff in rc5-mm3 which got dropped later on so
I don't have it any more.

> ok will resubmit later when we get a newer -mm update

Against 2.6.26-rc8 will work.
