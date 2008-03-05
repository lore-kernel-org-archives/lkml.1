Return-Path: <linux-kernel-owner+w=401wt.eu-S1762639AbYCEVlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639AbYCEVlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:41:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbYCEVlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:41:06 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:60263 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbYCEVlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:41:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UU8rwLRwlDywUaaMPyBZ4zajKx49mFl6PBoyHIQJ/bSGRMQ/EG3Bp8T+3Ahr6DPNTRHaAyEFHoZstRcdFWXXW6d22Pq7uNJc/Tw8WPd1jjDbzrrhlxEhfMd0dSl1SmhcILhglfVzA0ahvnrkYzeJ3pikE0Q0JpkGt9Flb9XMGzQ=
Message-ID: <84fc9c000803051340i13559c63tcf56eb828d000802@mail.gmail.com>
Date: Wed, 5 Mar 2008 22:40:59 +0100
From: "Richard Guenther" <richard.guenther@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction flag
Cc: "Joe Buck" <Joe.Buck@synopsys.com>, "Michael Matz" <matz@suse.de>,
       "Jan Hubicka" <hubicka@ucw.cz>, "Aurelien Jarno" <aurelien@aurel32.net>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
In-Reply-To: <47CF11D6.7070901@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080305153020.GA24631@volta.aurel32.net>
	 <20080305195834.GA17267@synopsys.com>
	 <20080305202319.GA17053@volta.aurel32.net>
	 <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
	 <20080305204234.GB17267@synopsys.com>
	 <20080305204945.GB14011@atrey.karlin.mff.cuni.cz>
	 <Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>
	 <20080305212005.GC17267@synopsys.com>
	 <84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
	 <47CF11D6.7070901@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 10:34 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Richard Guenther wrote:
>  >
>  > We didn't yet run into this issue and build openSUSE with 4.3 since more than
>  > three month.
>  >
>
>  Well, how often do you take a trap inside an overlapping memmove()?

Right.  So this problem is over-exaggerated.  It's not like
"any binary you create on that system will be broken on any
other existing system."

Richard.
