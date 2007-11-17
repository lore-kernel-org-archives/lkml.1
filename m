Return-Path: <linux-kernel-owner+w=401wt.eu-S1758023AbXKQN5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023AbXKQN5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 08:57:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbXKQN5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 08:57:32 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1848 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbXKQN5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 08:57:31 -0500
Date: Sat, 17 Nov 2007 13:57:00 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morgan <morgan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kevin Winchester <kjwinchester@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, kamalesh@linux.vnet.ibm.com
Subject: Re: 2.6.24-rc2-mm1 -- strange apparent network failures
Message-ID: <20071117135640.GA22058@shadowen.org>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <20071115100209.GB2513@shadowen.org> <200711152028.29734.kjwinchester@gmail.com> <20071115164441.67a8e2df.akpm@linux-foundation.org> <473E794A.4060107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473E794A.4060107@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2007 at 09:16:58PM -0800, Andrew Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hi,
> 
> This warning is just saying that you might want to reconsider
> recompiling your dhclient with a newer libcap - which has native support
> for 64-bit capabilities. This is supposed to be informative, and not be
> associated with any particular error.
> 
> - From your comments, you believe that this patch causes something in your
> boot process to fail. Can you supply some detail about the version of
> dhclient you are using? I'd like to understand exactly what it is doing
> (via libcap).
> 
> Thanks

The machine which show this problem for me are using static network
configurations, so I don't know if libcap is still in the mix there.

I've just compared the boot logs from a successful and unsuccessful boot
on this kernel, and I don't see that particular message, nor do I see
any significant differences overall.

Perlexed.

-apw
