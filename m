Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYKVDq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYKVDq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 22:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbYKVDqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 22:46:16 -0500
Received: from dmz4.indranet.co.nz ([203.97.93.68]:63666 "EHLO
	XServe-2.services.indranet.co.nz" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753619AbYKVDqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 22:46:15 -0500
Date: Sat, 22 Nov 2008 16:46:10 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
X-X-Sender: derek@monster
To: Bob Copeland <me@bobcopeland.com>
cc: Maxim Levitsky <maximlevitsky@gmail.com>, wally@theblackmoor.net,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ath5k-devel] Unusually low speeds with ath5k and iwl3945
In-Reply-To: <20081122005240.GA27826@hash.localnet>
Message-ID: <alpine.DEB.2.00.0811221643030.7067@monster>
References: <492719ED.5000006@gmail.com> <20081122005240.GA27826@hash.localnet>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  to verify that it is a rate control issue, there is one very simple and 
very practical test.

Take both ends of your link, and set them to fixed rate, and at the rate 
you think it should be achieving.
If you can achieve significantly higher throughputs with fixed rate, you 
know that the rate control algorithm (or interface with rate algorithm) 
has failed.

Derek.

On Fri, 21 Nov 2008, Bob Copeland wrote:

> On Fri, Nov 21, 2008 at 10:28:29PM +0200, Maxim Levitsky wrote:
>> I initially blamed iwl3945, then thought it got fixed, but now I have
>> ath5k, and speeds are low
>> and I suspect that both drivers has bugs regarding to speed.
>
> Quite possible, but both use mac80211 for rate control.  Which rate
> control algorithm are you using?
>
>

-- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
Email: derek@indranet.co.nz
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/

