Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbYLIJsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbYLIJsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 04:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYLIJry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 04:47:54 -0500
Received: from mga10.intel.com ([192.55.52.92]:25875 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752443AbYLIJrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 04:47:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,740,1220252400"; 
   d="scan'208";a="648174578"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: kvm@vger.kernel.org
Subject: Re: [PATCH 0/2] module_refcounting and anonymous inodes
Date: Tue, 9 Dec 2008 17:43:25 +0800
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; x86_64; ; )
Cc: Avi Kivity <avi@redhat.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <200812021114.59050.borntraeger@de.ibm.com> <200812081251.14648.borntraeger@de.ibm.com> <493D0B9A.9000401@redhat.com>
In-Reply-To: <493D0B9A.9000401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812091743.26586.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2008 19:57:14 Avi Kivity wrote:
> Christian Borntraeger wrote:
> > Am Dienstag, 2. Dezember 2008 schrieb Christian Borntraeger:
> >> Hello Avi,
> >>
> >> here is the latest respin of my fixes for the kvm module unload problem:
> >>
> >> [PATCH 1/2] anon_inodes: use fops->owner for module refcount
> >> [PATCH 2/2] kvm: set owner of cpu and vm file operations
> >
> > In the meantime patch 2 has a offset against the latest git. Should I
> > resend the patch or will you apply it anyway?
>
> Applied the patches; thanks for the reminder.

Should we push the first patch to 2.6.28? I got some trouble with the separate 
2nd patch, for I am using Linus' tree and make KVM as modules, so the 
reference count reduced to negative now... (Oh Avi, I know you suggest to use 
in kernel rather than modules, but module is indeed convenient. :) )

-- 
regards
Yang, Sheng
