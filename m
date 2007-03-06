Return-Path: <linux-kernel-owner+w=401wt.eu-S965242AbXCFQN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965242AbXCFQN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965271AbXCFQN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:13:57 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36021 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242AbXCFQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:13:56 -0500
Date: Tue, 6 Mar 2007 21:51:01 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, ebiederm@xmission.com,
       winget@google.com, containers@lists.osdl.org, menage@google.com,
       akpm@linux-foundation.org
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070306162101.GC7046@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <20070301113900.a7dace47.pj@sgi.com> <20070303093655.GA1028@in.ibm.com> <20070303173244.GA16051@MAIL.13thfloor.at> <20070305173401.GA17044@in.ibm.com> <20070305183937.GC22445@MAIL.13thfloor.at> <20070306103940.GA2336@in.ibm.com> <20070306132837.GA15495@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306132837.GA15495@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 02:28:39PM +0100, Herbert Poetzl wrote:
> groups like Memory, Disk Space, Sockets might make
> sense though, although we never had a single request
> for any overlapping in the resource management (while
> we have quite a few users of overlapping Network spaces)

If we have to provide this flexibilty of different groupings for
different resources, then I dont see how we can get to the limit with
less than 3 dereferences (unless we bloat the task_struct to point to
the various limit structures directly).

-- 
Regards,
vatsa
