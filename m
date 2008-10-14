Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYJNSTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYJNSTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 14:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYJNSTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 14:19:31 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:42026 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYJNSTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 14:19:30 -0400
X-IronPort-AV: E=Sophos;i="4.33,410,1220227200"; 
   d="scan'208";a="90823327"
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, Markus Metzger <markus.t.metzger@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: X86_DS config option needs better help text
X-Message-Flag: Warning: May contain useful information
Date: Tue, 14 Oct 2008 11:19:28 -0700
Message-ID: <adavdvvvy33.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 Oct 2008 18:19:29.0330 (UTC) FILETIME=[65CDE920:01C92E29]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Noticed while building a new kernel from latest git:

    Debug Store support (X86_DS) [Y/n/?] (NEW) ?

and asking for help just gives

    Add support for Debug Store.
    This allows the kernel to provide a memory buffer to the hardware
    to store various profiling and tracing events.

This doesn't really let me decide if I want it or not.  Is there a cost
to enabling this, and if so what?  What new feature does this give me?

Is there even a point to making this a user-visible option at all, or
should it just be an internal config variable selected by X86_PTRACE_BTS
and any future users of this?

X86_PTRACE_BTS also could use an improved help text.

No patch, sorry, since I don't actually know for sure what this does.

Thanks,
  Roland
