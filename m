Return-Path: <linux-kernel-owner+w=401wt.eu-S1763374AbYCEWq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763374AbYCEWq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758143AbYCEWqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:46:16 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:38778 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbYCEWqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:46:15 -0500
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2008 17:46:15 EST
Date: Wed, 5 Mar 2008 14:37:13 -0800
From: Joe Buck <Joe.Buck@synopsys.COM>
To: David Miller <davem@davemloft.net>
Cc: richard.guenther@gmail.com, hpa@zytor.com, matz@suse.de, hubicka@ucw.cz,
       aurelien@aurel32.net, linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Message-ID: <20080305223713.GF17267@synopsys.com>
References: <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com> <47CF11D6.7070901@zytor.com> <84fc9c000803051340i13559c63tcf56eb828d000802@mail.gmail.com> <20080305.141622.80343656.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305.141622.80343656.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2008 at 02:16:22PM -0800, David Miller wrote:
> From: "Richard Guenther" <richard.guenther@gmail.com>
> Date: Wed, 5 Mar 2008 22:40:59 +0100
> 
> > Right.  So this problem is over-exaggerated.  It's not like
> > "any binary you create on that system will be broken on any
> > other existing system."
> 
> I will be sure to hunt you down to help debug when someone reports
> that once every few weeks their multi-day simulation gives incorrect
> results :-)
> 
> This is one of those cases where the bug is going to be a huge
> issue to people who actually hit it, and since we know about the
> problem, knowingly shipping something in that state is unforgivable.

In this case, it appears that the 4.3.0 tarballs already hit the
servers before the issue was discovered.

It's not the end of the world; quite often .0 releases have some issue,
and we can patch the 4_3 branch and recommend that the patch be used.
