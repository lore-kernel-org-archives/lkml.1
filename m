Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbXI2IWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbXI2IWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 04:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbXI2IWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 04:22:38 -0400
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:35810 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbXI2IWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 04:22:37 -0400
Date: Sat, 29 Sep 2007 10:22:33 +0200
From: Wolfgang Erig <Wolfgang.Erig@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: regression in 2.6.23-rc8 - power off failed
Message-ID: <20070929082233.GA3447@erig.dyndns.org>
Mail-Followup-To: "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Alexey Starikovskiy <astarikovskiy@suse.de>
References: <20070929005453.GA4475@erig.dyndns.org> <46FDC0EB.3070003@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FDC0EB.3070003@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Both are bad.
Two different systems and two different bisections.
I sent the last step of each.

On Fri, Sep 28, 2007 at 08:05:15PM -0700, H. Peter Anvin wrote:
> Wolfgang Erig wrote:
> > Hi,
> > 
> > the latest kernel does not power off my system.
> > 
> > 2.6.22 succeeded
> > 2.6.23-rc8 failed
> > 
> > $ git bisect bad  
> > Bisecting: 0 revisions left to test after this 
> > [f216cc3748a3a22c2b99390fddcdafa0583791a2] ACPI: suspend: consolidate handling of Sx states.

This is fixed for me after pulling from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
Thankyou and sorry for the noise.

> > 
> > $ git bisect good 
> > Bisecting: 0 revisions left to test after this 
> > [626073132b381684c4983e0d911e9aceb32e2cbc] Assembly header and main routine for new x86 setup code 
> 
> OK, so which one is the bad one?

This problem (no power off) persists after pull some minutes ago.
Sorry for the confusion.

Wolfgang
