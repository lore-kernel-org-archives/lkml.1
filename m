Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbYG3TGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbYG3TGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbYG3TGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:06:32 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:57024 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbYG3TGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:06:31 -0400
X-IronPort-AV: E=Sophos;i="4.31,280,1215388800"; 
   d="scan'208";a="59562535"
From: Roland Dreier <rdreier@cisco.com>
To: Mike Miller <mike.miller@hp.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
Subject: Re: Problems building 2.6.26 and 2.6.27-rc1
References: <20080730184833.GA936@roadking.ldev.net>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 30 Jul 2008 12:06:22 -0700
In-Reply-To: <20080730184833.GA936@roadking.ldev.net> (Mike Miller's message
	of "Wed, 30 Jul 2008 13:48:33 -0500")
Message-ID: <adaiqunyyxd.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 30 Jul 2008 19:06:22.0695 (UTC) FILETIME=[5B4E5770:01C8F277]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I'm getting the following error when trying to build either 2.6.26 or
 > 2.6.27-rc1:
 > 
 > arch/x86/kernel/head64.c: In function ‘x86_64_start_kernel’:
 > arch/x86/kernel/head64.c:88: error: size of array ‘type name’ is negative

It looks like you're hitting

	BUILD_BUG_ON(!(MODULES_VADDR > __START_KERNEL));

No idea why you're hitting that though.  What's your .config and compiler?

 - R.
