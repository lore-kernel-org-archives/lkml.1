Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbZASWOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbZASWOp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753002AbZASWOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:14:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:7417 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbZASWOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:14:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,291,1231142400"; 
   d="scan'208";a="379740241"
Date: Mon, 19 Jan 2009 14:14:35 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Avuton Olrich <avuton@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due to dc1e35c
Message-ID: <20090119221434.GF31356@linux-os.sc.intel.com>
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com> <4974CC8B.1030403@zytor.com> <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com> <4974DD86.2090300@zytor.com> <20090119201115.GD31356@linux-os.sc.intel.com> <3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com> <20090119215736.GE31356@linux-os.sc.intel.com> <4974F9A8.7060107@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4974F9A8.7060107@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 02:07:36PM -0800, H. Peter Anvin wrote:
> Suresh Siddha wrote:
> > 
> > Also, I wonder, if we should complain/scream during boot if we find only
> > fewer cpuid levels on modern generation cpu's.
> > 
> 
> We should, or if this block is reversible, we should probably just undo 
> it (the reason people put this block in places is because of, ahem, 
> inferior operating systems having bugs.)
> 
> Do you know how this is managed?  Via an MSR?

IA32_MISC_ENABLE MSR bit 22
