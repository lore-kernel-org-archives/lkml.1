Return-Path: <linux-kernel-owner+w=401wt.eu-S1755874AbZJ2Dp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874AbZJ2Dp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 23:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZJ2Dp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 23:45:28 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:37477 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbZJ2Dp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 23:45:28 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANes6EqrR7H+/2dsb2JhbADDXpgMhD8E
X-IronPort-AV: E=Sophos;i="4.44,643,1249257600"; 
   d="scan'208";a="47311062"
From: Roland Dreier <rdreier@cisco.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] x86, mce: short output of MCE banks ownership information
References: <4AE90E43.2030709@jp.fujitsu.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 28 Oct 2009 20:45:31 -0700
In-Reply-To: <4AE90E43.2030709@jp.fujitsu.com> (Hidetoshi Seto's message of
	"Thu, 29 Oct 2009 12:38:43 +0900")
Message-ID: <adaaaza6exw.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 29 Oct 2009 03:45:32.0065 (UTC) FILETIME=[43BB4110:01CA584A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seems OK, but I think it would be even more useful to find a way to
print fewer lines of output; with CPUs that will be released shortly, a
system with 64 or even 128 logical CPUs will not be will not be that
exotic, and producing 128 lines of kernel log output for debugging
information that is rarely used and where the same info can be expressed
in 2 or 3 lines is silly-looking (and very annoying on a 57600 bps
serial console!).

 - Roland
