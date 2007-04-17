Return-Path: <linux-kernel-owner+w=401wt.eu-S1030657AbXDQPkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030657AbXDQPkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 11:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030608AbXDQPkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 11:40:19 -0400
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:1107 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030672AbXDQPkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 11:40:17 -0400
X-IronPort-AV: i="4.14,419,1170662400"; 
   d="scan'208"; a="370220522:sNHT44806584"
To: "Francis Moreau" <francis.moro@gmail.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, helge.hafting@aitel.hist.no,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [CRYPTO] is it really optimized ?
X-Message-Flag: Warning: May contain useful information
References: <38b2ab8a0704170659o3f65f5fbo94a59be58727d21c@mail.gmail.com>
	<E1HdoGm-0005WU-00@gondolin.me.apana.org.au>
	<38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Apr 2007 08:40:13 -0700
In-Reply-To: <38b2ab8a0704170741n619e169s6a2f3ac5b768a950@mail.gmail.com> (Francis Moreau's message of "Tue, 17 Apr 2007 16:41:00 +0200")
Message-ID: <adairbv57s2.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Apr 2007 15:40:13.0875 (UTC) FILETIME=[B0C3B030:01C78106]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Again, my code is faster only because I skip the key loading in 
 > "cia_encrypt" method. Actually the gain is bigger in decryption mode 
 > than in encryption one because I also generate the decryption key for 
 > each block.

I wonder if there's some way you can cache the last caller and reload
the key lazily (only when it changes).  Of course without your code
it's hard to say...
