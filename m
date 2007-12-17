Return-Path: <linux-kernel-owner+w=401wt.eu-S934874AbXLQKPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934874AbXLQKPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 05:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762619AbXLQKPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 05:15:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:13906 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762011AbXLQKPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 05:15:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NsNLcmq+8YVODEbXiClVOapRITD6utJeS7R62UCy/LsC8MIV3qHjBmbYeI8X4Ysc0lxdLoayfZltlHp2+leLjx2FVrP02xjHuHAW0OrahHBBvVclMLEDEo5PPBYT3i0DOuCshBVnoVwwx1rIQyhX9enxTi/uL81D3GQquyXCmAU=
Message-ID: <520b60a90712170215g7f3c8a2by7fdd74a1cdd1566f@mail.gmail.com>
Date: Mon, 17 Dec 2007 05:15:08 -0500
From: mvtodevnull@gmail.com
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH 3/3] net: wireless: bcm43xx: big_buffer_sem semaphore to mutex
Cc: "Larry Finger" <larry.finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, "Daniel Walker" <dwalker@mvista.com>,
       "Ray Lee" <ray-lk@madrabbit.org>,
       "=?ISO-8859-1?Q?Simon_Holm_Th=F8gersen?=" <odie@cs.aau.dk>,
       matthias.kaehlcke@gmail.com, linux-kernel@vger.kernel.org,
       linux@bohmer.net, "Ingo Molnar" <mingo@elte.hu>, kjwinchester@gmail.com,
       jonathan@jonmasters.org, akpm@linux-foundation.org,
       bcm43xx-dev@lists.berlios.de
In-Reply-To: <200712171049.06291.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213003028.676998182@mvista.com>
	 <47661CA1.3080808@lwfinger.net>
	 <520b60a90712162317r5c2f2569gbd75c09742ff5493@mail.gmail.com>
	 <200712171049.06291.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 4:49 AM, Michael Buesch <mb@bu3sch.de> wrote:
>
> Are you working with wireless-2.6's #everything branch?

I've been working with vanilla wireless-2.6, but I've also tried the
everything branch as well as other trees. Just for good measure, I
just rebuilt the everything branch and it shows the same behavior.
