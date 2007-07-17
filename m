Return-Path: <linux-kernel-owner+w=401wt.eu-S1758714AbXGQDsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714AbXGQDsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 23:48:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXGQDsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 23:48:43 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:50907 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbXGQDsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 23:48:42 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAGTYm0arR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.16,544,1175497200"; 
   d="scan'208"; a="183238208:sNHT28258389"
To: Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "OF-General" <general@lists.openfabrics.org>,
       Joachim Fenkes <fenkes@de.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 01/10] IB/ehca: Support for multiple event queues
X-Message-Flag: Warning: May contain useful information
References: <OF2377E85C.B05BDE94-ONC125731A.006E64A7-C125731A.00714F9E@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 16 Jul 2007 20:48:40 -0700
In-Reply-To: <OF2377E85C.B05BDE94-ONC125731A.006E64A7-C125731A.00714F9E@de.ibm.com> (Hoang-Nam Nguyen's message of "Mon, 16 Jul 2007 22:37:44 +0200")
Message-ID: <ada1wf7vgfb.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jul 2007 03:48:41.0253 (UTC) FILETIME=[5D91CD50:01C7C825]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > No, I've no figures to provide here. The background of this dist_eqs
 > option is actually to allow us testing across all event queues
 > without to change the testcases resp consumers to use certain
 > event queue number. Thus, I should comment it as EXPERIMENTAL?

Seems like it's just development/testing code that shouldn't escape
into the wild?

 > > I think I would rather hold off on multiple EQs for this merge window
 > > and plan on having something really solid and thought-out for 2.6.24.

 > Fair enough. However why don't let us gather experience with this
 > feature now? Should we remove dist_eqs option for more consistency?

As I said I definitely think the dist_eqs switch doesn't sound like
something we want to expose to people.

With that said I still am not sure about putting the multiple EQs
feature in this release.  All the infrastructure is there to make
experimenting with it fairly painless (just the low-level driver needs
to change), and I still haven't seen much code using the feature or
even any anecdotal information about the performance impact.
