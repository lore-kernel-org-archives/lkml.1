Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbZEGTWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbZEGTWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZEGTWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:22:08 -0400
Received: from sous-sol.org ([216.99.217.87]:49662 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754946AbZEGTWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:22:07 -0400
Date: Thu, 7 May 2009 12:21:45 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Avi Kivity <avi@redhat.com>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
Message-ID: <20090507192145.GF3036@sequoia.sous-sol.org>
References: <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com> <4A032771.6050703@redhat.com> <4A032A74.2020809@novell.com> <4A032FDD.8020209@redhat.com> <20090507190751.GE3036@sequoia.sous-sol.org> <4A033281.8050002@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A033281.8050002@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gregory Haskins (ghaskins@novell.com) wrote:
> Chris Wright wrote:
> > * Avi Kivity (avi@redhat.com) wrote:
> >> Gregory Haskins wrote:
> >>> Cool,  I will code this up and submit it.  While Im at it, Ill run it
> >>> through the "nullio" ringer, too. ;)  It would be cool to see the
> >>> pv-mmio hit that 2.07us number.  I can't think of any reason why this
> >>> will not be the case.
> >>>       
> >> Don't - it's broken.  It will also catch device assignment mmio and  
> >> hypercall them.
> >
> > Not necessarily.  It just needs to be creative w/ IO_COND
> 
> Hi Chris,
>    Could you elaborate?  How would you know which pages to hypercall and
> which to let PF?

Was just thinking of some ugly mangling of the addr (I'm not entirely
sure what would work best).
