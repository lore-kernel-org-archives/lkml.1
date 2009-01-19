Return-Path: <linux-kernel-owner+w=401wt.eu-S1759468AbZASV5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759468AbZASV5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZASV5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:57:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:2883 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170AbZASV5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:57:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,291,1231142400"; 
   d="scan'208";a="423709289"
Date: Mon, 19 Jan 2009 13:57:36 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Avuton Olrich <avuton@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due to dc1e35c
Message-ID: <20090119215736.GE31356@linux-os.sc.intel.com>
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com> <4974CC8B.1030403@zytor.com> <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com> <4974DD86.2090300@zytor.com> <20090119201115.GD31356@linux-os.sc.intel.com> <3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aa654a40901191346i12cc736m40bebd422100a088@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 01:46:37PM -0800, Avuton Olrich wrote:
> On Mon, Jan 19, 2009 at 12:11 PM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> > Avuton, Does your bios has an option which says limit the cpuid
> > vector limit to '2' or something. Can you disable that option and
> > re-check? It will typically be located under cpu configuration settings.
> 
> You're the winner of the prize. The culprit in my bios was:
>
> Max CPUID Value Limit: Enabled

Though the bios is the culprit and this option will severely limit
the cpu capabilities that OS can take advantage of, OS should fallback
to a safer mode. I will have a patch for it.

Also, I wonder, if we should complain/scream during boot if we find only
fewer cpuid levels on modern generation cpu's.

thanks,
suresh
