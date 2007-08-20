Return-Path: <linux-kernel-owner+w=401wt.eu-S1759919AbXHTNo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919AbXHTNo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 09:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbXHTNoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 09:44:21 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:35015 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbXHTNoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 09:44:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18121.39541.790665.686081@stoffel.org>
Date: Mon, 20 Aug 2007 09:43:17 -0400
From: "John Stoffel" <john@stoffel.org>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Cc: Ingo Molnar <mingo@elte.hu>, kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 0/4] Virtual Machine Time Accounting
In-Reply-To: <46C99371.7070705@bull.net>
References: <46C99371.7070705@bull.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Laurent> The aim of these four patches is to introduce Virtual Machine
Laurent> time accounting.

So what does this buy us?  What increased functionality?  

Laurent> [PATCH 1/4] as recent CPUs introduce a third running state,
Laurent> after "user" and "system", we need a new field, "guest", in
Laurent> cpustat to store the time used by the CPU to run virtual
Laurent> CPU. Modify /proc/stat to display this new field.

What happens when you have multiple guests, is this state cummulative?  

I've glanced over these patches and the #ifdefs are ugly..., esp since
the overhead seems to exist even if you don't run any Guest CPUs.  Or
whatever you're doing here.

Please justify this patch more in terms of what it provides and why
it's a good thing to have.  

Thanks,
John
