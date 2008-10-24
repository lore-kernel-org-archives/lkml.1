Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbYJXXPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbYJXXPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYJXXPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:15:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:35870 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbYJXXPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:15:18 -0400
Subject: Re: linux-next: Tree for October 24 - powerpc - build failure with
	!CONFIG_BLK_DEV_IDEDMA_PMAC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       bzolnier@gmail.com
In-Reply-To: <49024EA3.1080404@ru.mvista.com>
References: <20081024171932.1e8131d0.sfr@canb.auug.org.au>
	 <20081024113856.GA4252@linux.vnet.ibm.com> <4901BC5E.7040607@ru.mvista.com>
	 <1224886062.7654.464.camel@pasglop>  <49024EA3.1080404@ru.mvista.com>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 10:10:18 +1100
Message-Id: <1224889818.7654.466.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-25 at 02:39 +0400, Sergei Shtylyov wrote:
> >>    Hm, looks like this configuration was never buildable --
> #ifdef's are 
> >> missing and wrongly placed. CCing Ben Herrenschmidt...
> >>     
> >
> > What configuration ?
> >   
> 
>    See the subject.

Ah ok. We should probably just remove the option...

Ben.


