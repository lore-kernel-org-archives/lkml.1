Return-Path: <linux-kernel-owner+w=401wt.eu-S1756033AbYCBQEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbYCBQEA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 11:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYCBQDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 11:03:53 -0500
Received: from ns.theshore.net ([67.18.92.50]:44910 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbYCBQDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 11:03:53 -0500
Message-ID: <47CACFBE.5010007@theshore.net>
Date: Sun, 02 Mar 2008 11:03:10 -0500
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: virtualization@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Xen paravirt frontend block hang
References: <4772AC8E.7010007@theshore.net> <47C712EF.1060703@goop.org> <47C9F818.4020200@theshore.net> <47CAC931.1000107@goop.org>
In-Reply-To: <47CAC931.1000107@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Are you running an SMP or UP domain?  I found I could get hangs very 
> easily with UP (but I need confirm it isn't a result of some other very 
> experimental patches).

The hang occurs with both SMP and UP compiled pv_ops kernels.  SMP 
kernels are still slightly responsive after the hang occurs, which makes 
me think only one proc gets stuck at a time, not the entire kernel.

-Chris

