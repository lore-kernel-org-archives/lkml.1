Return-Path: <linux-kernel-owner+w=401wt.eu-S1760627AbYCDG2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760627AbYCDG2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 01:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbYCDG2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 01:28:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:60346 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbYCDG2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 01:28:37 -0500
Date: Mon, 3 Mar 2008 22:23:21 -0800
From: Greg KH <greg@kroah.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 pci: remove checking type for mmconfig probe v2
Message-ID: <20080304062321.GB16019@kroah.com>
References: <200802271639.52958.yinghai.lu@sun.com> <200802282356.50496.yinghai.lu@sun.com> <20080301060236.GE20032@kroah.com> <86802c440803010036u2cb89a30h2adb90b3ee497cfc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440803010036u2cb89a30h2adb90b3ee497cfc@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 01, 2008 at 12:36:50AM -0800, Yinghai Lu wrote:
> On Fri, Feb 29, 2008 at 10:02 PM, Greg KH <greg@kroah.com> wrote:
> > On Thu, Feb 28, 2008 at 11:56:50PM -0800, Yinghai Lu wrote:
> >  >
> >  > doesn't need to check if it is type1 or type2. we can use raw_pci_ops dirctly.
> >
> >  Why?  is this because the ops are already set up?  It would be nice to
> >  add the "why this change is necessary and/or possible now" for the
> >  changelog.
> yes.
> raw_pci_ops got assigned when check direct_type1 and direct_type2.
> and could used in hostbridge check to get MMCONF base.
> 
> make mmconfig probe clean
> with checking if raw_pci_ops is assigned instead of passing type or
> checking type.

Ah, ok, that makes sense, thanks.

greg k-h
