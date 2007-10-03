Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbXJCUEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbXJCUEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 16:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXJCUDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 16:03:52 -0400
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:20507 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbXJCUDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 16:03:51 -0400
X-IronPort-AV: E=Sophos;i="4.21,226,1188802800"; 
   d="scan'208";a="531024451"
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Roland Dreier <roland@digitalvampire.org>, Greg KH <greg@kroah.com>,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: MSI: Use correct data offset for 32-bit MSI in read_msi_msg()
X-Message-Flag: Warning: May contain useful information
References: <87abr0oyj4.fsf@shaolin.home.digitalvampire.org>
	<m1ir5ocaxr.fsf@ebiederm.dsl.xmission.com>
	<874ph8ovtm.fsf@shaolin.home.digitalvampire.org>
	<m17im4c6sh.fsf@ebiederm.dsl.xmission.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Wed, 03 Oct 2007 13:03:44 -0700
In-Reply-To: <m17im4c6sh.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's message of "Wed, 03 Oct 2007 13:55:10 -0600")
Message-ID: <adaejgcdkyn.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 03 Oct 2007 20:03:45.0366 (UTC) FILETIME=[80F57F60:01C805F8]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > Well it is a bug worth fixing.  Who knows it may have something
 > to do with the disable_irq problems the forcedeth driver was seeing.

I agree completely, the fix looks obvious and there's no point in
leaving the bug there.  I just don't have a test case that I can point
to as being fixed by this, since I don't have a working 32-bit MSI
device...

Do you know whether the forcedeth devices have a 32-bit MSI address?

 - R.
