Return-Path: <linux-kernel-owner+w=401wt.eu-S1753232AbYLEF4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232AbYLEF4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 00:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbYLEF4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 00:56:05 -0500
Received: from relay3.sgi.com ([192.48.171.31]:54462 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751462AbYLEF4E (ORCPT
	<rfc822;@relay.corp.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 00:56:04 -0500
X-Greylist: delayed 699 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2008 00:56:04 EST
Message-ID: <4938BFAE.5090504@sgi.com>
Date: Fri, 05 Dec 2008 16:44:14 +1100
From: Timothy Shimmin <tes@sgi.com>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Mikulas Patocka <mpatocka@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Alasdair G Kergon <agk@redhat.com>,
       Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support
References: <Pine.LNX.4.64.0812040009340.15169@hs20-bc2-1.build.redhat.com>	<20081204100050.GN6703@one.firstfloor.org>	<Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>	<20081204142015.GQ6703@one.firstfloor.org>	<Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com> <20081204145810.GR6703@one.firstfloor.org>
In-Reply-To: <20081204145810.GR6703@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> The write block with barrier bit varies, jbd/gfs2 do it synchronously
> too and xfs does it asynchronously (with io done callbacks), but
> in both cases they handle an EOPNOTSUPP comming out in the final
> io done.
> 
Yes, XFS handles it, however,
it doesn't look like we currently propagate the EOPNOTSUPP
up to where we test it (not set for b_error).
Patch disscussed recently on xfs list to rectify this.

--Tim

