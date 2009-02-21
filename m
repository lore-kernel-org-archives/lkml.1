Return-Path: <linux-kernel-owner+w=401wt.eu-S1754676AbZBUKek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbZBUKek (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 05:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZBUKec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 05:34:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:19634 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbZBUKeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 05:34:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,245,1233561600"; 
   d="scan'208";a="667421610"
Subject: Re: [patch 03/36] Fix Intel IOMMU write-buffer flushing
From: David Woodhouse <david.woodhouse@intel.com>
To: Thomas Backlund <tmb@mandriva.org>
Cc: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <499DF274.8040702@mandriva.org>
References: <20090218222447.432108614@mini.kroah.org>
	 <20090218222901.GD10668@kroah.com> <499C9394.5030704@mandriva.org>
	 <499DF274.8040702@mandriva.org>
Organization: Intel Corporation
Date: Sat, 21 Feb 2009 11:34:21 +0100
Message-Id: <1235212461.3536.27.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-19 at 23:59 +0000, Thomas Backlund wrote:
>  
> That's what my patch fixes, by simply moving
> 
> static int rwbf_quirk = 0;
> 
> to the beginning of the file...

s/ = 0//

It was originally hard-coded to something other than zero, and I
neglected to remove the initialiser when I changed it to zero after
working out the correct PCI ID to trigger on.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

---------------------------------------------------------------------
Intel Corporation (UK) Limited
Registered No. 1134945 (England)
Registered Office: Pipers Way, Swindon SN3 1RJ
VAT No: 860 2173 47

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

