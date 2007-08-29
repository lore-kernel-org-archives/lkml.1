Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbXH2Fff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbXH2Fff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 01:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbXH2FfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 01:35:25 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:1374 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbXH2FfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 01:35:24 -0400
X-IronPort-AV: i="4.19,320,1183359600"; 
   d="scan'208"; a="518219714:sNHT46367846"
To: Divy Le Ray <divy@chelsio.com>
Cc: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>
Subject: Re: [PATCH 2.6.23 0/2] cxgb3 - Fix dev->priv usage
X-Message-Flag: Warning: May contain useful information
References: <46D4F12C.7090409@chelsio.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 28 Aug 2007 22:35:23 -0700
In-Reply-To: <46D4F12C.7090409@chelsio.com> (Divy Le Ray's message of "Tue, 28 Aug 2007 21:08:12 -0700")
Message-ID: <ada3ay26gys.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Aug 2007 05:35:23.0588 (UTC) FILETIME=[656BD840:01C7E9FE]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Looks OK to me but I would just roll up the second patch into the
first patch and let Jeff merge it as one commit.  There's no point in
creating an intermediate tree that doesn't build -- it just breaks git
bisect for no useful purpose.

Also as a side note, when trying to test this I got the message

    could not load TP SRAM: unable to load t3a_protocol_sram-1.0.44.bin

and you guys seem to only have t3b protocol sram images on your web
site.  Could you send me the t3a file (or swap out my T3A boards for
T3B boards ;)?

Thanks,
  Roland
