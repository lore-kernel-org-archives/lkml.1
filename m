Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbZDVWJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbZDVWJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755168AbZDVWJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:09:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:22240 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbZDVWJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:09:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,232,1239001200"; 
   d="scan'208";a="405895444"
Date: Wed, 22 Apr 2009 15:08:52 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86/pci: do assign root bus res if _CRS is used
Message-ID: <20090422150852.3ea4989b@hobbes>
In-Reply-To: <49ED22EC.2040204@kernel.org>
References: <49ED22EC.2040204@kernel.org>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 18:35:40 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> it wil be overwriten later if _CRS is used, so don't bother to set it.
> 
> [ Impact: cleanup ]

Applied, thanks.

A general comment on your patches though: please spent a few more
minutes coming up with readable & useful summaries & changelogs.  Most
of the time when applying your patches (which are generally fine
technically) I have to delete the whole changelog and come up with a
new one based on reading the sources and then your patch.  It would be
nice if I didn't have to.  Grammar and spelling mistakes are fine (I
usually catch those) but when the logic of the changelog is all wrong,
or it doesn't describe what it's doing and why, it makes things much
more difficult.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
