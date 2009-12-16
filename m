Return-Path: <linux-kernel-owner+w=401wt.eu-S1762498AbZLPRPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762498AbZLPRPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 12:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762279AbZLPRPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 12:15:14 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:47047 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761494AbZLPRPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 12:15:12 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAJ6kKEurR7Hu/2dsb2JhbADAEpcFhCsEgWM
X-IronPort-AV: E=Sophos;i="4.47,407,1257120000"; 
   d="scan'208";a="450694335"
From: Roland Dreier <rdreier@cisco.com>
To: Tziporet Koren <tziporet@mellanox.co.il>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
       Yevgeny Petrilin <yevgenyp@mellanox.co.il>
Subject: Re: InfiniBand/RDMA merge plans for 2.6.33
References: <adaocm1csgb.fsf@roland-alpha.cisco.com>
	<4B28A259.3040909@mellanox.co.il>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Dec 2009 09:15:09 -0800
In-Reply-To: <4B28A259.3040909@mellanox.co.il> (Tziporet Koren's message of
	"Wed, 16 Dec 2009 11:03:21 +0200")
Message-ID: <ada1viualia.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Dec 2009 17:15:10.0195 (UTC) FILETIME=[5261A430:01CA7E73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > >   - mlx4 SR-IOV support.  Again, main problem was my lack of time.  I
 > >     agree in principle with this stuff, just want to be careful that we
 > >     don't turn the mlx4 driver into an unmaintainable mess of "if
 > >     (sriov) something; else something_else" all over.

 > Roland,
 > You have not sent any comments to our patches that were sent few weeks
 > ago on time for 2.6.32 inclusion,
 > and now I am surprised you do not accept them for 2.6.32.
 > I think we still have time to work together and fix your concerns on
 > mlx4 driver.
 > Can you send more concrete comments so we can fix them?

As I said (in the text you quoted), the main problem is my lack of
time.  I want to read the patches over again, and I suspect we will have
one more iteration before they are ready to go.  There does seem to be a
lot of changing from

	/* pv code */

to

	if (sriov) {
		/* sriov code */
	} else {
		/* completely different pv code */
	}

which is to say the least not beautiful.

More broadly there is a problem that I am doing 99% of the code review
for RDMA kernel patches.  Occasionally people get interested in isolated
things, but for the most part the expectation seems to be that I will
review everything, which doesn't scale.

 > Since we have a HW that supports SRIOV and many people are interested
 > in this new technology for KVM thus it is important that we drive it
 > now

If you send a 25-patch series after -rc6, you should expect that there
is a good chance of missing the next merge window.  Sorry -- with the
current process of expecting me to be the only reviewer for nearly
everything, I simply am not going to be able to get through things in time.

 - R.
