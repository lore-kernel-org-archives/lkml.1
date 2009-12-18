Return-Path: <linux-kernel-owner+w=401wt.eu-S933100AbZLRWUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100AbZLRWUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 17:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZLRWUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 17:20:06 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:31117 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZLRWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 17:20:05 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEABuPK0urRN+K/2dsb2JhbAC+fZcghC4EgWQ
X-IronPort-AV: E=Sophos;i="4.47,420,1257120000"; 
   d="scan'208";a="122219784"
From: Roland Dreier <rdreier@cisco.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Simon Horman <horms@verge.net.au>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kexec\@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: kexec reboot broken with ioatdma?
References: <ada3a3a8v1g.fsf@roland-alpha.cisco.com>
	<20091216224912.GC16219@verge.net.au>
	<aday6l27c7w.fsf@roland-alpha.cisco.com> <4B296930.9020704@intel.com>
	<adatyvq7bbi.fsf@roland-alpha.cisco.com>
	<1261174241.16958.6.camel@dwillia2-linux.ch.intel.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 18 Dec 2009 14:20:02 -0800
In-Reply-To: <1261174241.16958.6.camel@dwillia2-linux.ch.intel.com> (Dan
	Williams's message of "Fri, 18 Dec 2009 15:10:41 -0700")
Message-ID: <adafx773ox9.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Dec 2009 22:20:03.0311 (UTC) FILETIME=[3EC11FF0:01CA8030]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Subject: ioat2,3: put channel hardware in known state at init
 > 
 > Put the ioat2 and ioat3 state machines in the halted state with all
 > errors cleared.

Yes, with this applied I was able to kexec reboot from a kernel with
ioatdma loaded and have ioatdma work in the new kernel.  So:

Tested-by: Roland Dreier <rolandd@cisco.com>

Thanks!
