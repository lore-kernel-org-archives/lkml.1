Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbZASUL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbZASUL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 15:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbZASULS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 15:11:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:24514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbZASULR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 15:11:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,290,1231142400"; 
   d="scan'208";a="379713676"
Date: Mon, 19 Jan 2009 12:11:16 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Avuton Olrich <avuton@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due to dc1e35c
Message-ID: <20090119201115.GD31356@linux-os.sc.intel.com>
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com> <4974CC8B.1030403@zytor.com> <3aa654a40901191131p7c141378m1bcd3baeed098e09@mail.gmail.com> <4974DD86.2090300@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4974DD86.2090300@zytor.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 12:07:34PM -0800, H. Peter Anvin wrote:
> Avuton Olrich wrote:
> > 2009/1/19 H. Peter Anvin <hpa@zytor.com>:
> >>> bisected to:
> >>> commit dc1e35c6e95e8923cf1d3510438b63c600fee1e2
> >>> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> >>> Date:   Tue Jul 29 10:29:19 2008 -0700
> >>>
> >> Avuton, could you please compile the attached program and send us the
> >> output?
> > 
> > Sure whichever flavor you prefer:
> > http://avuton.googlepages.com/cpuid-out (3M)
> > http://avuton.googlepages.com/cpuid-out.bz2 (40K)
> 
> OK, that's an XSAVE-capable CPU, and yet the XSAVE code causes a crash. 
>   Not good...

Avuton, Does your bios has an option which says limit the cpuid
vector limit to '2' or something. Can you disable that option and
re-check? It will typically be located under cpu configuration settings.

My system which has same stepping etc works just fine. But my bios doesn't
have the cpuid limit option. I need to check if this issue is because
of the cpuid limit option that is enabled in the bios.

thanks,
suresh
