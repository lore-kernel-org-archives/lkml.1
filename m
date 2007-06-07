Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbXFGIrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbXFGIrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbXFGIrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:47:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:46257 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639AbXFGIrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:47:13 -0400
Date: Thu, 7 Jun 2007 10:47:11 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Message-ID: <20070607084711.GB15226@one.firstfloor.org>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011407.51779.jbarnes@virtuousgeek.org> <20070601211943.GO7217@one.firstfloor.org> <200706011441.57149.jbarnes@virtuousgeek.org> <m1r6orwptz.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0706041420100.25811@p34.internal.lan> <20070604201823.7b7cb328@the-village.bc.nu> <m1myzfwi0x.fsf@ebiederm.dsl.xmission.com> <86802c440706041759q1b2d528ex24b3de514d09d9ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440706041759q1b2d528ex24b3de514d09d9ef@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 05:59:59PM -0700, Yinghai Lu wrote:
> On 6/4/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >
> >Exactly, and given that this is a fairly easy thing to do, and that
> >occasionally we see systems where this happens (even if their BIOS is
> >later fixed).  It is likely worth it for someone to write up the patch
> >and that compare MTRRs with available memory, and to complain and
> >reserve all memory that MTRRs claim is not write-back.
> >
> that is good.
> Sometime BIOS can not even keep mtrr to the identical between
> different CPU in SMP system.

The MTRR code already fixes this case. Or at least mostly -- 
it doesn't do it for fixed size MTRRs.

> Or reset mtrr according to e820 table.

That would be likely dangerous.

-Andi
