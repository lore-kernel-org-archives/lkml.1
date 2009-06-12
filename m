Return-Path: <linux-kernel-owner+w=401wt.eu-S1762843AbZFLObt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762843AbZFLObt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbZFLObl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:31:41 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:5543 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbZFLObk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:31:40 -0400
X-IronPort-AV: E=Sophos;i="4.42,210,1243814400"; 
   d="scan'208";a="199066573"
From: Roland Dreier <rdreier@cisco.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "Barnes\, Jesse" <jesse.barnes@intel.com>, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: mthca double free irqs
References: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 12 Jun 2009 07:31:42 -0700
In-Reply-To: <86802c440906111945n2a42dc94mf08bd2b1a252842f@mail.gmail.com>
	(Yinghai Lu's message of "Thu, 11 Jun 2009 19:45:21 -0700")
Message-ID: <adak53h1q29.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 12 Jun 2009 14:31:42.0576 (UTC) FILETIME=[81567F00:01C9EB6A]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, will take a look.  It does seem this is on an error path:

 > [  606.818317] ib_mthca 0000:c4:00.0: NOP command failed to generate
 > interrupt (IRQ 98), aborting.
 > [  606.826709] ib_mthca 0000:c4:00.0: BIOS or ACPI interrupt routing problem?

So your system already had problems -- the driver didn't get an
expected interrupt from the device.

 - R.
