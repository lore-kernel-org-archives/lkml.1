Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbYCEXRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbYCEXRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760930AbYCEXQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:16:53 -0500
Received: from us01smtp1.synopsys.com ([198.182.44.79]:49263 "EHLO
	boden.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936AbYCEXQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:16:52 -0500
Date: Wed, 5 Mar 2008 15:16:43 -0800
From: Joe Buck <Joe.Buck@synopsys.COM>
To: David Miller <davem@davemloft.net>
Cc: matz@suse.de, hpa@zytor.com, richard.guenther@gmail.com, hubicka@ucw.cz,
       aurelien@aurel32.net, linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Message-ID: <20080305231642.GG17267@synopsys.com>
References: <Pine.LNX.4.64.0803052341330.20583@wotan.suse.de> <47CF25A5.5060709@zytor.com> <Pine.LNX.4.64.0803060006520.20583@wotan.suse.de> <20080305.151012.07703232.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305.151012.07703232.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 03:10:12PM -0800, David Miller wrote:
> From: Michael Matz <matz@suse.de>
> Date: Thu, 6 Mar 2008 00:07:39 +0100 (CET)
> 
> > The fix lies in the kernel, the work-around in gcc.
> 
> This depends upon how you interpret this ABI situation.
> 
> There is at least some agreement that how things have
> actually been implemented by these kernels for more
> than 15 years trumps whatever a paper standard states.

We had a similar argument about the undefinedness of signed int
overflow.  That's what the standard says, yet code that assumes
otherwise is pervasive, including in gcc itself.

If a standard is widely violated in a very consistent way, the violation
in effect becomes standard.
