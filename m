Return-Path: <linux-kernel-owner+w=401wt.eu-S1765192AbXGQRx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765192AbXGQRx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933038AbXGQRxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:53:00 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:54856 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765016AbXGQRw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:52:59 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CACeenEarR7PE/2dsb2JhbAA
X-IronPort-AV: i="4.16,546,1175497200"; 
   d="scan'208"; a="167023261:sNHT28557918"
To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
Cc: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>, Joachim Fenkes <fenkes@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       OF-General <general@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 01/10] IB/ehca: Support for multiple event queues
X-Message-Flag: Warning: May contain useful information
References: <OF2377E85C.B05BDE94-ONC125731A.006E64A7-C125731A.00714F9E@de.ibm.com>
	<ada1wf7vgfb.fsf@cisco.com> <20070717043740.GB8527@mellanox.co.il>
From: Roland Dreier <rdreier@cisco.com>
Date: Tue, 17 Jul 2007 10:52:55 -0700
In-Reply-To: <20070717043740.GB8527@mellanox.co.il> (Michael S. Tsirkin's message of "Tue, 17 Jul 2007 07:37:40 +0300")
Message-ID: <adalkdesyrs.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jul 2007 17:52:55.0386 (UTC) FILETIME=[4DC91BA0:01C7C89B]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Here's some anecdotal evidence :)
 > http://lists.openfabrics.org/pipermail/general/2007-May/035758.html

Right, but then we went on to say that we probably want to use
multiple vectors to separate out multiple HCA ports rather than
send/sreceive on the same port.  And the current IPoIB implementation
of having that second CQ seems suboptimal anyway, since it seems to
leave us susceptible to the interrupt overload that NAPI was supposed
to solve.

At a higher level, I'm left wondering why nobody talked about multiple
EQs during the last months of the 2.6.22 process and now all of a
sudden it becomes urgent in the last few days of the 2.6.23 merge
window.  That's not really how I like to merge features....

 - R.
