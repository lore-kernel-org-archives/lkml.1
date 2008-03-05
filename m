Return-Path: <linux-kernel-owner+w=401wt.eu-S1761857AbYCEVcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761857AbYCEVcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbYCEVci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:32:38 -0500
Received: from gv-out-0910.google.com ([216.239.58.189]:59046 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYCEVch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:32:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pqI9PEUsEHsd8f/TUCoQEALYzRMkWErLRETQCyyO0kbw+nFmq1MAYyKhBeiQjETDb4BI9QMWG7yJZ/pxkCcdv9yh+G11C9Unl45m2Pd3Rc1xpvwJan4UKUHF32T1+p59bfbZDDmDrYDqUqY0EjoRash1TA8DvEzCdyWdaeXOU0g=
Message-ID: <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
Date: Wed, 5 Mar 2008 22:32:34 +0100
From: "Richard Guenther" <richard.guenther@gmail.com>
To: "Joe Buck" <Joe.Buck@synopsys.com>
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Cc: "Michael Matz" <matz@suse.de>, "Jan Hubicka" <hubicka@ucw.cz>,
       "Aurelien Jarno" <aurelien@aurel32.net>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
In-Reply-To: <20080305212005.GC17267@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080305153020.GA24631@volta.aurel32.net>
	 <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com>
	 <20080305202319.GA17053@volta.aurel32.net>
	 <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
	 <20080305204234.GB17267@synopsys.com>
	 <20080305204945.GB14011@atrey.karlin.mff.cuni.cz>
	 <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>
	 <20080305212005.GC17267@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 10:20 PM, Joe Buck <Joe.Buck@synopsys.com> wrote:
>
>
>  On Wed, 5 Mar 2008, Jan Hubicka wrote:
>  > > Linux kernel is disabling red zone and use kernel code model, yet the
>  > > ABI is not going to be adjusted for that.
>  > >
>  > > This is resonably easy to fix on kernel side in signal handling, or by
>  > > removing std usage completely
>
>  On Wed, Mar 05, 2008 at 10:02:07PM +0100, Michael Matz wrote:
>  > That is true.  But it requires updating the kernel to a fixed one if you
>  > want to run your programs compiled by 4.3 :-/  Not something we'd like to
>  > demand.
>
>  I changed the title just for emphasis.
>
>  I think that we can't ship 4.3.0 if signal handlers on x86/x86_64
>  platforms for both Linux and BSD systems will mysteriously (to the users)
>  fail, and it doesn't matter whose fault it is.

We didn't yet run into this issue and build openSUSE with 4.3 since more than
three month.

Richard.
