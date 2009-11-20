Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbZKTAav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbZKTAav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 19:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758020AbZKTAau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 19:30:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:14224 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757923AbZKTAau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 19:30:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,773,1249282800"; 
   d="scan'208";a="515660711"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Roland Dreier'" <rdreier@cisco.com>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: <general@lists.openfabrics.org>, <linux-next@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
References: <20091120110342.5128b8f8.sfr@canb.auug.org.au> <ada1vju6oa6.fsf@roland-alpha.cisco.com>
Subject: RE: linux-next: infiniband tree build failure
Date: Thu, 19 Nov 2009 16:30:55 -0800
Message-ID: <6307584467EB4D168602C43E0B185157@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcppdyFKoXyqrY3GQpeG4r9lST7cXQAAIrtQ
In-Reply-To: <ada1vju6oa6.fsf@roland-alpha.cisco.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Sorry, will track it down.  Sean this probably came from your patches,
>any idea off the top of your head?

Off the top of my head, I'll guess that maybe we need to add something like

#if defined(CONFIG_IPv6) || defined(CONFIG_IPV6_MODULE)

to cma_check_linklocal() in cma.c.  Does this build failure occur when IPv6 is
excluded?

- Sean

