Return-Path: <linux-kernel-owner+w=401wt.eu-S1760123AbXGQDu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123AbXGQDu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 23:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754778AbXGQDuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 23:50:17 -0400
Received: from sj-iport-1-in.cisco.com ([171.71.176.70]:32139 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbXGQDuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 23:50:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAM7Ym0arR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.16,544,1175497200"; 
   d="scan'208"; a="8869886:sNHT13508778"
To: Joachim Fenkes <FENKES@de.ibm.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 10/10] IB/ehca: Support large page MRs
X-Message-Flag: Warning: May contain useful information
References: <OFD7499E67.C6B5EA9B-ONC125731A.00715FED-C125731A.007484A7@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 16 Jul 2007 20:50:13 -0700
In-Reply-To: <OFD7499E67.C6B5EA9B-ONC125731A.00715FED-C125731A.007484A7@de.ibm.com> (Joachim Fenkes's message of "Mon, 16 Jul 2007 23:11:47 +0200")
Message-ID: <adatzs3u1sa.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Jul 2007 03:50:13.0534 (UTC) FILETIME=[9492C3E0:01C7C825]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > Why the module parameter?  Is there any reason a user would want to
 > > turn this off?  Or conversely, why is it off by default?
 > 
 > We're pretty confident this new feature works, but as with all new and 
 > possibly experimental features, there are chances it might explode your 
 > machine when activated. So, like with the scaling code, we want the user 
 > to make the conscious decision of using this code instead of activating it 
 > by default.

OK, I guess.  So can we expect to, say, change the default to turning
it on for 2.6.24 and remove the option entirely (so it's always on) in
2.6.25?

 - R.
