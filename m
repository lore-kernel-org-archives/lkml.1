Return-Path: <linux-kernel-owner+w=401wt.eu-S1752840AbYJCOBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbYJCOBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 10:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYJCOBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 10:01:46 -0400
Received: from ik-out-1112.google.com ([66.249.90.177]:57062 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbYJCOBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:01:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H6LrJ1ZGcKOQ4RVpmCFhgX39eEObFBLTFVeFP2sNtGCHFXgfQL1NAwixX3yakBnf6C
         CbYb8CW9mTNrT4fr0hGZqBBdhvMfJYV+PaNenBdVDWbUAtDnsmdFMiQeHK005swQE7SN
         j2ZKv+2XzPnjAYq470e1o4V0zBA0Xl7TotiMY=
Date: Fri, 3 Oct 2008 18:01:40 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tej <bewith.tej@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org
Subject: Re: Kernel PANIC with 2.6.27-rc6
Message-ID: <20081003140140.GA7595@localhost>
References: <f1c9d250809110841s5c3d08b9ha93f0ef1da58642a@mail.gmail.com> <48C94F65.3050405@windriver.com> <f1c9d250809250735i4b98201ft753d6ec2959097e6@mail.gmail.com> <20080925145635.GA7277@localhost> <20080925154724.GB7277@localhost> <f1c9d250809251134j6fac8bfu43f08cbf2b330f0a@mail.gmail.com> <20080925193956.GF7259@localhost> <20080926085033.GA16849@localhost> <f1c9d250810030348h5c61241fg79bf769e1da16a8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1c9d250810030348h5c61241fg79bf769e1da16a8@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Tej - Fri, Oct 03, 2008 at 04:18:55PM +0530]
| On 9/26/08, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > [Cyrill Gorcunov - Thu, Sep 25, 2008 at 11:39:56PM +0400]
| > | [Tej - Fri, Sep 26, 2008 at 12:04:30AM +0530]
| > | ...
| > |
| > | Btw Tej, could you please apply this patch
| > | and check if it help.
| > |
| > | 	http://lkml.org/lkml/2008/9/22/250
| > |
| > | Aristeu Rozanski fixed one race window which take
| > | place on unpredicted nmi's.
| > |
| > | 		- Cyrill -
| >
| > Btw Tej, could you post boot log if kernel were started as
| >
| > 	root=/dev/sda1 ro debug apic=debug kgdbts=V2 splash console=tty0
| > console=ttyS0,
| sorry for this long pause.
| 
| machine boots fine with the options specified, and logs are collected
| as follows.
| some warning related to sysctl table checking, but its related to
| libvirtd (KVM) at the end.
|

ok, lets assume NMI race is fixed

		- Cyrill -
