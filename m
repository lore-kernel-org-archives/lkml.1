Return-Path: <linux-kernel-owner+w=401wt.eu-S1756068AbYCTNsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbYCTNsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 09:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbYCTNsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 09:48:35 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:18133 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbYCTNse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 09:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ld1fmDVJtclkGzfP9vtUtYkEv/MOzDuRpPeswQd9pLtkbatR6jZxWXnUH+23BiZj/pEec2Dg+d7iP18i/9qKMTZFjakIFvpWEcMb5I5M3BQVWF73d/JI2mZxnfILspYQttbrNN9aXgPfUyXNGtKBrV18fZT1JW5y7Qf6iRDr0YU=
Message-ID: <939d53060803200648s422969b5m429fa444bdcacc35@mail.gmail.com>
Date: Thu, 20 Mar 2008 14:48:33 +0100
From: "Benjamin Thery" <ben.thery@gmail.com>
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: [2.6.25-rc5-mm1] regression: cannot run Postfix sendmail command as non-root
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "David Miller" <davem@davemloft.net>,
       akpm@linux-foundation.org, tilman@imap.cc, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, pekkas@netcore.fi, yoshfuji@linux-ipv6.org,
       dlezcano@fr.ibm.com, ebiederm@xmission.com
In-Reply-To: <47E25DF5.3090107@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D98510.60801@imap.cc>
	 <20080319.154947.78332548.davem@davemloft.net>
	 <939d53060803200126k563b9ae7l7197dea4e96ba1ed@mail.gmail.com>
	 <200803201121.07633.rjw@sisk.pl> <47E25DF5.3090107@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 1:52 PM, Pavel Emelyanov <xemul@openvz.org> wrote:
>
> Rafael J. Wysocki wrote:
>  > On Thursday, 20 of March 2008, Benjamin Thery wrote:
>  >> On Wed, Mar 19, 2008 at 11:49 PM, David Miller <davem@davemloft.net> wrote:
>  >>> From: Andrew Morton <akpm@linux-foundation.org>
>  >>>  Date: Wed, 19 Mar 2008 14:16:08 -0700
>  >>>
>  >>>
>  >>>  > Although this is advertised as a 2.6.25-rc5-mm1 problem, I assume the
>  >>>  > regression is also in mainline? 2.6.25-rc6?
>  >>>
>  >>>  It is in 2.6.25-rc6, correct.
>  >>>
>  >>>  If Pavel or someone else doesn't produce a good fix soon
>  >>>  I'll revert the guilty change as this bug is worse than
>  >>>  the problem that changeset fixes.
>  >> Andre Noll sent a patch to LKML, acked by Pavel:
>  >>
>  >> "Fix permissions of /proc/net"
>  >> http://thread.gmane.org/gmane.linux.kernel/655148
>  >
>  > Have you tested that patch?
>
>  I did - works OK, that's why I Acked it.

Also tested here. It fixes the regression.


Benjamin
