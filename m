Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYEFSFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYEFSFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbYEFSFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:05:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42649 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbYEFSFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:05:30 -0400
Date: Tue, 6 May 2008 13:05:27 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cmm@us.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/8] Scaling msgmni to the amount of lowmem
Message-ID: <20080506180527.GA8315@sergelap.austin.ibm.com>
References: <20080211141646.948191000@bull.net> <20080211141813.354484000@bull.net> <12c511ca0804291328v2f0b87csd0f2cf3accc6ad00@mail.gmail.com> <481EC917.6070808@bull.net> <1FE6DD409037234FAB833C420AA843EC014392F9@orsmsx424.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FE6DD409037234FAB833C420AA843EC014392F9@orsmsx424.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Luck, Tony (tony.luck@intel.com):
> > Well, this printk had been suggested by somebody (sorry I don't remember 
> > who) when I first submitted the patch. Actually I think it might be 
> > useful for a sysadmin to be aware of a change in the msgmni value: we 
> > have the message not only at boot time, but also each time msgmni is 
> > recomputed because of a change in the amount of memory.
> 
> If the message is directed at the system administrator, then it would
> be nice if there were some more meaningful way to show the namespace
> that is affected than just printing the hex address of the kernel structure.
> 
> As the sysadmin for my test systems, printing the hex address is mildly
> annoying ... I now have to add a new case to my scripts that look at
> dmesg output for unusual activity.
> 
> Is there some better "name for a namespace" than the address? Perhaps
> the process id of the process that instantiated the namespace???

I agree with Tony here.  Aside from the nuisance it is to see that
message on console every time I unshare a namespace, a printk doesn't
seem like the right way to output the info.  At most I'd say an audit
message.

-serge
