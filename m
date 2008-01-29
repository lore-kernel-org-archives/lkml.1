Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYA2Rne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYA2Rne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:43:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbYA2RnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:43:08 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46242 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbYA2RnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:43:04 -0500
Date: Tue, 29 Jan 2008 11:43:14 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Rishikesh K Rajak <risrajak@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, vgusev@openvz.org,
       balbir@linux.vnet.ibm.com, containers@lists.osdl.org,
       Poornima Nayak <Poornima.Nayak@in.ibm.com>, serue@linux.vnet.ibm.com,
       sukadev@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Devel] LTP result output for container-init ( failure with
	2.6.24 kernel )
Message-ID: <20080129174314.GA2858@sergelap.austin.ibm.com>
References: <1200497268.3999.17.camel@localhost.localdomain> <47986165.4050407@openvz.org> <OFDB71F099.8DF97877-ON652573DF.00581FA6-652573DF.00591A31@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFDB71F099.8DF97877-ON652573DF.00581FA6-652573DF.00591A31@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Rishikesh K Rajak (risrajak@in.ibm.com):
> 
> 
> Hi Pavel/Vitaliy,
> 
> Pavel Emelyanov <xemul@openvz.org> wrote on 01/24/2008 03:29:01 PM:
> 
> > Rishikesh K. Rajak wrote:
> > > Hi All,
> > >
> > > Today i ran full LTP on kernel 2.6.24-rc6 inside container-init and
> also
> > > on parent namespace and got some observations.
> > >
> > > Here is the machine information:
> > >     Linux rishi.in.ibm.com 2.6.18-53.el5 #1 SMP Wed Oct 10 16:34:02 EDT
> > > 2007 i686 i686 i386 GNU/Linux
> > >
> > >     OS: SLES 10
> > >
> > > I found these fcntl are failing inside container and it pass on parent
> > > namespace. I am attaching the log file with this mail.
> > >
> > > These failures are conceding with 2.6.23-mm1 itself. Just wanted to
> know
> > > if someone is working on this still.
> > >
> > >   fcntl11                        FAIL
> > >   fcntl14                        FAIL
> > >   fcntl17                        FAIL
> > >   fcntl19                        FAIL
> > >   fcntl20                        FAIL
> > >   fcntl21                        FAIL
> 
> Today, I tested 2.6.24 kernel and ran LTP inside container, and found that
> the above failure is still existing.
> These failures are not occuring when i run LTP in parent namespace.

Vitaliy's fix is in 2.6.24-rc8-mm1, but not in 2.6.24.

thanks,
-serge
