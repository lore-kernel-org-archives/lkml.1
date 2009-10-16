Return-Path: <linux-kernel-owner+w=401wt.eu-S932406AbZJPTH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbZJPTH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 15:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932380AbZJPTH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 15:07:26 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:21414 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbZJPTHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 15:07:23 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEADNh2EqrR7Ht/2dsb2JhbADBGZgfhDAE
X-IronPort-AV: E=Sophos;i="4.44,574,1249257600"; 
   d="scan'208";a="411061412"
From: Roland Dreier <rdreier@cisco.com>
To: landman@scalableinformatics.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
       Anand Babu Periasamy <ab@gluster.com>
Subject: Re: kernel BUG at drivers/pci/intel-iommu.c:1278
References: <4AD8A393.3040907@scalableinformatics.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 16 Oct 2009 11:58:36 -0700
In-Reply-To: <4AD8A393.3040907@scalableinformatics.com> (Joe Landman's message
	of "Fri, 16 Oct 2009 12:47:15 -0400")
Message-ID: <ada63afxj1f.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 16 Oct 2009 18:58:36.0752 (UTC) FILETIME=[AA945500:01CA4E92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Anything I should look for?  I know 2.6.28 is not being developed any
 > further.  Should I start looking at 2.6.31 to help with this?

Definitely looking at 2.6.31 or even 2.6.32-rc kernels to see if this
still happens would be a good idea.  I've not done much IB work with
VT-d enabled, but the fact that the BUG() is in drivers/pci seems to
indicate that the problem is fairly likely to be some internal
corruption in the intel_iommu code, caused by a bug there, rather than
anything IB related.

 - R.
