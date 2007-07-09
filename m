Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbXGIWML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbXGIWML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 18:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754478AbXGIWL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 18:11:59 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:15451 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbXGIWL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 18:11:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CABZPkkarR7PD/2dsb2JhbAA
X-IronPort-AV: i="4.16,519,1175497200"; 
   d="scan'208"; a="179147426:sNHT3578356008"
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH 00/13] IB/ehca: eHCA2 enablement & some fixes
X-Message-Flag: Warning: May contain useful information
References: <200707091502.22407.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 09 Jul 2007 15:11:42 -0700
In-Reply-To: <200707091502.22407.fenkes@de.ibm.com> (Joachim Fenkes's message of "Mon, 9 Jul 2007 15:02:21 +0200")
Message-ID: <adak5t9w7kx.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Jul 2007 22:11:42.0531 (UTC) FILETIME=[21616930:01C7C276]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

thanks, I applied these for 2.6.23 and fixed a bunch of minor things
that scripts/checkpatch.pl complained about (since I was in a mood to
do mindless things).  In the future please run that yourself and clean
up the obvious things.  I generally don't worry about the 80 column
stuff, but it will catch most whitespace problems and tell you that
foo(x,y) should be foo(x, y) etc.  So you don't have to completely
silence the script but at least take a look at the output.
