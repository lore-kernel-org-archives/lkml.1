Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZEKPDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZEKPDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZEKPDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:03:11 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:62917 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753070AbZEKPDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:03:09 -0400
From: Frans Pop <elendil@planet.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ACPI: do not mark TSC unstable for invalid C-states
Date: Mon, 11 May 2009 17:03:07 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       len.brown@intel.com, mingo@elte.hu, johnstul@us.ibm.com
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com> <200905110226.50115.elendil@planet.nl> <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0905111614570.3561@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905111703.08645.elendil@planet.nl>
X-OriginalArrivalTime: 11 May 2009 15:03:09.0185 (UTC) FILETIME=[98A02F10:01C9D249]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 May 2009, Thomas Gleixner wrote:
> commit a71e4917dc0ebbcb5a0ecb7ca3486643c1c9a6e2 (ACPI: idle:
> mark_tsc_unstable() at init-time, not run-time) marks TSC unstable
> even on non affected systems.
>
> The reason is that the state enumeration does not check the cx->valid
> flag before calling tsc_halts_in_c(), so it marks TSC unstable for any
> enumerated albeit invalid C state which is known to turn off TSC.
>
> Check cx->valid before checking whether the TSC might become unstable.
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Tested-by: Frans Pop <elendil@planet.nl>

Thanks Thomas.
