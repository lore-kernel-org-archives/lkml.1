Return-Path: <linux-kernel-owner+w=401wt.eu-S1752285AbXCLXbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbXCLXbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbXCLXbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:31:14 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:41340 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbXCLXbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:31:14 -0400
Date: Tue, 13 Mar 2007 00:31:13 +0100
From: Herbert Poetzl <herbert@13thfloor.at>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, pj@sgi.com,
       ebiederm@xmission.com, winget@google.com, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070312233113.GD6832@MAIL.13thfloor.at>
Mail-Followup-To: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
	"Serge E. Hallyn" <serue@us.ibm.com>,
	ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	xemul@sw.ru, pj@sgi.com, ebiederm@xmission.com, winget@google.com,
	containers@lists.osdl.org, Paul Menage <menage@google.com>,
	akpm@linux-foundation.org
References: <20070307173031.GC2336@in.ibm.com> <20070307174346.GA19521@sergelap.austin.ibm.com> <20070307180055.GC17151@in.ibm.com> <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com> <20070309163430.GN6504@in.ibm.com> <6599ad830703091409s3d233829gb8f0afbfd2883b15@mail.gmail.com> <20070312150756.GB24742@in.ibm.com> <20070312155643.GA12893@sergelap.austin.ibm.com> <20070312162045.GD12176@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312162045.GD12176@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2007 at 09:50:45PM +0530, Srivatsa Vaddagiri wrote:
> On Mon, Mar 12, 2007 at 10:56:43AM -0500, Serge E. Hallyn wrote:
> > What's wrong with that?
> 
> I had been asking around on "what is the fundamental unit of res mgmt
> for vservers" and the answer I got (from Herbert) was "all tasks that are
> in the same pid namespace". From what you are saying above, it seems to
> be that there is no such "fundamental" unit. It can be a random mixture
> of tasks (taken across vservers) whose resource consumption needs to be
> controlled. Is that correct?

just means that the current Linux-VServer behaviour
is a subset of that, no problem there as long as
it really _is_ a subset :) we always like to provide
more features in the future, no problem with that :)

best,
Herbert

> > > 	echo "cid 2" > /dev/cpu/prof/tasks 
> > 
> > Adding that feature sounds fine, 
> 
> Ok yes ..that can be a optional feature.
> 
> -- 
> Regards,
> vatsa
> _______________________________________________
> Containers mailing list
> Containers@lists.osdl.org
> https://lists.osdl.org/mailman/listinfo/containers
