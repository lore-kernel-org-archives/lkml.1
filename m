Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbXLLAMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbXLLAMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:12:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbXLLAMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:12:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:44443 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbXLLAMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:12:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iOmJv/4alOtUtqKFv3HWY20uehNDYXedLPhSSZ9q3sRZGdPEp4wKrlatu1T3c2fCP5CPsllK0t/uqdUvIZh8rqxAOX/V+r3iq/k2+1RcjG4iYuwY0+3yB9ko5aqtBFPszXPWS/GHerBN0dB7ziIzWLADhI5Hm3qC1MzfxsQ9vEs=
Message-ID: <b25c3fa70712111612o16a62b49g6709aa728f31e27a@mail.gmail.com>
Date: Wed, 12 Dec 2007 09:12:05 +0900
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: [PATCH] [NET]: Fix Ooops of napi net_rx_action.
Cc: "David Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F5203F82FC3@orsmsx418.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <001801c83bd6$2001d410$9c94fea9@jason>
	 <20071211.023218.31965443.davem@davemloft.net>
	 <b25c3fa70712110457g2bf04c6flc387f2b9cb51cf3b@mail.gmail.com>
	 <36D9DB17C6DE9E40B059440DB8D95F5203F82FC3@orsmsx418.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/12, Brandeburg, Jesse <jesse.brandeburg@intel.com>:
>
> all drivers using NAPI in 2.6.24+ (NNAPI??) must return zero here, after
> calling netif_rx_complete.  netif_rx_complete plus work_done != 0 causes
> a bug.
>

Brandeburg,
Don't we need to return non-zero work_done after netif_rx_complete if
work_done != weight?

Thanks,
Joonwoo
