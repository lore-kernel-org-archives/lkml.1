Return-Path: <linux-kernel-owner+w=401wt.eu-S1762719AbYCEVnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762719AbYCEVnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:43:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762977AbYCEVnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:43:20 -0500
Received: from us01smtp1.synopsys.com ([198.182.44.79]:46851 "EHLO
	boden.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762849AbYCEVnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:43:19 -0500
Date: Wed, 5 Mar 2008 13:43:12 -0800
From: Joe Buck <Joe.Buck@synopsys.COM>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Guenther <richard.guenther@gmail.com>, Michael Matz <matz@suse.de>,
       Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction  flag
Message-ID: <20080305214311.GD17267@synopsys.com>
References: <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de> <20080305204234.GB17267@synopsys.com> <20080305204945.GB14011@atrey.karlin.mff.cuni.cz> <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de> <20080305212005.GC17267@synopsys.com> <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CF11D6.7070901@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 01:34:14PM -0800, H. Peter Anvin wrote:
> Richard Guenther wrote:
> >
> >We didn't yet run into this issue and build openSUSE with 4.3 since more 
> >than
> >three month.
> >
> 
> Well, how often do you take a trap inside an overlapping memmove()?

Also, would it be possible to produce an exploit?  If you can get string
instructions to work "the wrong way", you might be able to overwrite data.

"We haven't seen a problem" isn't the right answer.  Can someone
deliberately *create* a problem?

And if we aren't sure, we should err on the side of safety.


