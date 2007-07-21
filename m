Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbXGUENP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbXGUENP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 00:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750706AbXGUEM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 00:12:59 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:57178 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbXGUEM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 00:12:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CACQloUarR7O6/2dsb2JhbAA
X-IronPort-AV: i="4.16,565,1175497200"; 
   d="scan'208"; a="186013549:sNHT62510940"
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, raisch@de.ibm.com, stefan.roscher@de.ibm.com,
       fenkes@de.ibm.com
Subject: Re: [PATCH 2/5] ehca: Generate event when SRQ limit reached
X-Message-Flag: Warning: May contain useful information
References: <200707201602.19142.hnguyen@linux.vnet.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 20 Jul 2007 21:12:52 -0700
In-Reply-To: <200707201602.19142.hnguyen@linux.vnet.ibm.com> (Hoang-Nam Nguyen's message of "Fri, 20 Jul 2007 16:02:18 +0200")
Message-ID: <ada7iou75tn.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Jul 2007 04:12:53.0144 (UTC) FILETIME=[689DC980:01C7CB4D]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, applied.

BTW, does your SRQ-capable hardware support generating the "last WQE
reached" event?  There's not any reliable way to avoid problems when
destroying QPs attached to an SRQ without it, and the IB spec requires
CAs that support SRQs to generate it (o11-5.2.5 in chapter 11 of vol 1).

I don't see any code in ehca to generate the event, and IPoIB CM at
least will be very unhappy when using SRQs if the event is not
generated.

 - R.
