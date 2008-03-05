Return-Path: <linux-kernel-owner+w=401wt.eu-S1765152AbYCEKHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765152AbYCEKHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759987AbYCEKHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:07:01 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:4132 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759696AbYCEKHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:07:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:reply-to:to:cc:in-reply-to:references:content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding:from;
        b=ZBvmfvs1JEvJshXZ2VS+T1bgRcTWO/RLz9wxcMgQ0XTz0+0GfAhQbScmFopmtk20/k0rJThYn3uU9FnDCfnKOELwSZP/e/7XkQbcBc9bWWs0Dv0PmpURGInlsDpx+MtQ/0RW0PnCzJNqCVtrQhLtzgcyzjPSfvq9epLxHx8myPs=
Subject: Re: [kvm-devel] [RFC] Notifier for Externally Mapped Memory (EMM)
Reply-To: dor.laor@qumranet.com
To: Robin Holt <holt@sgi.com>
Cc: Avi Kivity <avi@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       Steve Wise <swise@opengridcomputing.com>,
       Andrea Arcangeli <andrea@qumranet.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, general@lists.openfabrics.org,
       akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20080305094736.GA2013@sgi.com>
References: <20080303213707.GA8091@v2.random>
	 <20080303220502.GA5301@v2.random> <47CC9B57.5050402@qumranet.com>
	 <Pine.LNX.4.64.0803032327470.9642@schroedinger.engr.sgi.com>
	 <20080304133020.GC5301@v2.random>
	 <Pine.LNX.4.64.0803041059110.13957@schroedinger.engr.sgi.com>
	 <20080304222030.GB8951@v2.random>
	 <Pine.LNX.4.64.0803041422070.20821@schroedinger.engr.sgi.com>
	 <1204670529.6241.52.camel@lappy> <47CE2B23.6010505@qumranet.com>
	 <20080305094736.GA2013@sgi.com>
Content-Type: text/plain
Organization: Qumranet
Date: Wed, 05 Mar 2008 12:02:57 +0200
Message-Id: <1204711377.31109.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
From: Dor Laor <dor.laor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-05 at 03:47 -0600, Robin Holt wrote:
> On Wed, Mar 05, 2008 at 07:09:55AM +0200, Avi Kivity wrote:
> > Isn't that out of the question for .25?
> 
> I keep hearing this mantra.  What is so compelling about the .25
> release?  When seems to be more important than what.  While I understand
> product release cycles, etc. and can certainly agree with them. I would
> like to know with what I am being asked to agree.
> 

The main reason is that several kvm exciting features are dependent on
mmu notifiers:
- It enables full guest swapping (as opposed to partial today)
- It enables memory ballooning
- It enables running Izik Eidus's Kernel Shared Pages module that unify
  guest pages together.

The patchset is kernel-internal, stable and reviewed. Even if the
interface will be changed in .26 it won't have noticeable effect.

So since its stable, internal, reviewed, needed to enable important kvm
features we like to see it in for .25.

Regards,
Dor

> That said, I agree we should probably finish getting the comments on
> Andrea's most recent patch, if any, cleared up and put that one in.
> 
> Robin
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> kvm-devel mailing list
> kvm-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kvm-devel

