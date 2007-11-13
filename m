Return-Path: <linux-kernel-owner+w=401wt.eu-S1760151AbXKMBWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbXKMBWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 20:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759875AbXKMBV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 20:21:59 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:49742 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759780AbXKMBV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 20:21:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uGIt2Y32gO2eXpdP2C1slTwHC1VwPvNBQ3HWiJffMFvY67hPlpJFRCLgTZUa1grUHaMWouxDgsHNSWp1MaGHORoBDSXR9ccRMKM/zuU9QsIjpp8TKD84APKFrs0h8AKaAeYNws4MwDv1l7DJxLz+1329uuOsnrbH7fiIBnVmCbg=
Message-ID: <b25c3fa70711121721o32bcab0fldf64ff0434a44a3c@mail.gmail.com>
Date: Tue, 13 Nov 2007 10:21:57 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous mode
Cc: w@1wt.eu, cfriesen@nortel.com, kaber@trash.net, auke-jan.h.kok@intel.com,
       netdev@vger.kernel.org, djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
In-Reply-To: <20071112.154046.117031917.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071112231516.GA15227@1wt.eu>
	 <20071112.151923.77768525.davem@davemloft.net>
	 <20071112233257.GA15524@1wt.eu>
	 <20071112.154046.117031917.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/13, David Miller <davem@davemloft.net>:
> From: Willy Tarreau <w@1wt.eu>
> Date: Tue, 13 Nov 2007 00:32:57 +0100
>
> > At least, being able to disable the feature at module load time
> > would be acceptable. Many people who often need to sniff on decent
> > machines would always keep it disabled.
>
> I'm willing to accept the feature, in whatever form, as long
> as the performance issue is dealt with properly.

I agree with disabling the hw acceleration feature by manually would
be a non-negative solution.
IMO implementation in the ethtool seems better than module param.
As like Auke mentioned.
If you guys confirm it, I'll try it.

Thanks.
Joonwoo
