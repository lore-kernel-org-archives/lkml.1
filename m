Return-Path: <linux-kernel-owner+w=401wt.eu-S1764093AbYCEHN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764093AbYCEHN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbYCEHNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:13:48 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:52691 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751588AbYCEHNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:13:47 -0500
Date: Wed, 5 Mar 2008 12:43:38 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/1]a new optional function for task assignment to
	cgroup
Message-ID: <20080305071338.GA7588@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <47CE322A.9060907@ak.jp.nec.com> <6599ad830803042156y5a28978fi995eb9050f8f5320@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830803042156y5a28978fi995eb9050f8f5320@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2008 at 09:56:13PM -0800, Paul Menage wrote:
> Hi Kazunaga,
> 
> On Tue, Mar 4, 2008 at 9:39 PM, Kazunaga Ikeno <k-ikeno@ak.jp.nec.com> wrote:
> > Hi -
> >
> >  This is a patch of a new optional function for task assignment to cgroup, RFC.
> >
> >
> >  == Purpose =================================================
> >
> >  To provide the function that leads a task, corresponding to the conditions specified
> >  beforehand, to a specific cgroup directory.
> >
> 
> This is something that's been discussed before, originally as part of
> CKRM with a complex rule engine in the kernel space.
> 
> Basically, the general agreement was that it's a case where a simple
> API is going to be too simple for the majority of users, and a complex
> API that satisfies everyone is going to be too messy/heavyweight.
> 
> This is something that can be done in a userspace daemon via the
> process events connector - when you get a PROC_EVENT_UID event, you
> can move the process into the appropriate cgroup (you may also need to
> check any recently-forked children). This also gives you more
> flexibility than you can have in the kernel - you can base your
> decision on more complex factors than simply the uid of the process.
> 
> Dhaval Giani had a prototype implementation of such a daemon.
> 

The daemon was posted at
http://article.gmane.org/gmane.linux.kernel/553267 . At that point
control groups were called containers. These corrections will have to
made for it to run.

If I can get the time, I will clean it up and try to put it up
somewhere.

Thanks,

-- 
regards,
Dhaval
