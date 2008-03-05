Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYCED5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYCED5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 22:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYCED44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 22:56:56 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:60532 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYCED4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 22:56:55 -0500
X-Greylist: delayed 3224 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2008 22:56:55 EST
To: kyle@mcmartin.ca
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, tomof@acm.org, kyle@parisc-linux.org,
       matthew@wil.cx, grundler@parisc-linux.org, akpm@linux-foundation.org
Subject: Re: [PATCH -mm 0/3] fix iommu segment boundary problems (parisc)
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080302171311.GB18883@phobos.i.cabal.ca>
References: <1204438228-4564-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20080302171311.GB18883@phobos.i.cabal.ca>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080305125415Y.fujita.tomonori@lab.ntt.co.jp>
Date: Wed, 05 Mar 2008 12:54:15 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008 12:13:11 -0500
Kyle McMartin <kyle@mcmartin.ca> wrote:

> On Sun, Mar 02, 2008 at 03:10:25PM +0900, FUJITA Tomonori wrote:
> > This patchset is another sequel to my patchset to fix iommu segment
> > boundary problems, IOMMUs allocate memory areas without considering a
> > low level driver's segment boundary limits:
> > 
> > http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg11919.html
> > 
> 
> This looks fine. Are you able to test this? If not, we can set you up
> with an account on a machine with remote console and all that jazz, if
> you'd like to.

Thanks for the offer!

I don't have any parisc hardware. If -mm kernels are tested well with
parisc, I'd be happy to leave it in your guys' hands since I've never
used parisc and the patches seem to work (with the bug fix for 32bits
boxes).

I'd like to try if there are not people who try -mm kernels with
parisc or a bug that I can't fix easily will be found.

Thanks,
