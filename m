Return-Path: <linux-kernel-owner+w=401wt.eu-S1753050AbXCMCPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050AbXCMCPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 22:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbXCMCPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 22:15:37 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60897 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbXCMCPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 22:15:36 -0400
Date: Tue, 13 Mar 2007 07:52:34 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Herbert Poetzl <herbert@13thfloor.at>
Cc: ckrm-tech@lists.sourceforge.net, xemul@sw.ru, linux-kernel@vger.kernel.org,
       pj@sgi.com, ebiederm@xmission.com, winget@google.com,
       containers@lists.osdl.org, "Serge E. Hallyn" <serue@us.ibm.com>,
       Paul Menage <menage@google.com>, akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070313022234.GA9881@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070307174346.GA19521@sergelap.austin.ibm.com> <20070307180055.GC17151@in.ibm.com> <20070307205846.GB7010@sergelap.austin.ibm.com> <6599ad830703071320ib687019h34d2e66c4abc3794@mail.gmail.com> <20070309163430.GN6504@in.ibm.com> <6599ad830703091409s3d233829gb8f0afbfd2883b15@mail.gmail.com> <20070312150756.GB24742@in.ibm.com> <20070312155643.GA12893@sergelap.austin.ibm.com> <20070312162045.GD12176@in.ibm.com> <20070312233113.GD6832@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070312233113.GD6832@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 12:31:13AM +0100, Herbert Poetzl wrote:
> just means that the current Linux-VServer behaviour
> is a subset of that, no problem there as long as
> it really _is_ a subset :) we always like to provide
> more features in the future, no problem with that :)

Considering the example Sam quoted, doesn't it make sense to split
resource classes (some of them atleast) independent of each other?
That would also argue for providing multiple hierarchy feature in Paul's
patches.

Given that and the mail Serge sent on why nsproxy optimization is
usefull given numbers, can you reconsider your earlier proposals as
below:

	- pid_ns and resource parameters should be in a single struct
	  (point 1c, 7b in [1])

	- pointers to resource controlling objects should be inserted
	  in task_struct directly (instead of nsproxy indirection)
	  (points 2c in [1])

[1] http://lkml.org/lkml/2007/3/12/138

-- 
Regards,
vatsa
