Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZECLve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZECLve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 07:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZECLvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 07:51:13 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43786 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163AbZECLvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 07:51:11 -0400
Subject: Re: Next April 28: boot failure on PowerPC with SLQB
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <npiggin@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Sachin Sant <sachinp@in.ibm.com>,
       linuxppc-dev@ozlabs.org, linux-next@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090430141029.GG6900@wotan.suse.de>
References: <49F938E4.2030703@in.ibm.com>
	 <20090430064127.GF23746@wotan.suse.de> <49F973A0.8070106@in.ibm.com>
	 <20090430103528.GA6900@wotan.suse.de>
	 <1241087884.19252.5.camel@penberg-laptop>
	 <20090430210004.05a61841.sfr@canb.auug.org.au>
	 <20090430111825.GC6900@wotan.suse.de>
	 <1241090429.19252.7.camel@penberg-laptop>
	 <20090430130542.GF6900@wotan.suse.de>
	 <20090501000033.ecce9ed8.sfr@canb.auug.org.au>
	 <20090430141029.GG6900@wotan.suse.de>
Date: Sun, 03 May 2009 14:51:11 +0300
Message-Id: <1241351471.26995.5.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-30 at 16:10 +0200, Nick Piggin wrote:
> On Fri, May 01, 2009 at 12:00:33AM +1000, Stephen Rothwell wrote:
> > Hi Nick,
> > 
> > On Thu, 30 Apr 2009 15:05:42 +0200 Nick Piggin <npiggin@suse.de> wrote:
> > >
> > > Hmm, this might do it. The following code now passes some stress testing
> > > in a userspace harness wheras before it did not (and was obviously wrong).
> > 
> > Indeed that allows it to boot fine.  Thanks.
> > 
> > Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> Great, thanks for reporting and testing. This one is especially
> important because it is basically scribbling on random memory
> :( Pekka, please apply.

Applied, thanks!

