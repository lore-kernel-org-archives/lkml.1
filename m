Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbYAGTOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbYAGTOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:14:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753138AbYAGTOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:14:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:57388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113AbYAGTOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:14:05 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Mark Lord <lkml@rtr.ca>
Subject: Re: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Date: Mon, 7 Jan 2008 14:12:59 -0500
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Arjan van de Ven <arjan@infradead.org>, abelay@novell.com,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, rjw@sisk.pl
References: <20071130142058.816d1693.akpm@linux-foundation.org> <20080106231848.762e93c1.akpm@linux-foundation.org> <4782400D.2040802@rtr.ca>
In-Reply-To: <4782400D.2040802@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071412.59964.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Why does VMware need max_cstate=1 to load quickly?
   It should not, and the fact that it does means
   that something somewhere is seriously broken.

2. Why does the "max_csate=1" workaround help only
   on the dual-core boxes, while the single-core
   boxes still fail to load quickly?

I'm glad that we deleted run-time access to max_cstate --
it seems to have exposed a real bug that needs fixing
and has gone unreported until now.

Indeed, when the real bug is fixed, I propose that
we again move to delete max_cstate as a run-time API.

-Len
