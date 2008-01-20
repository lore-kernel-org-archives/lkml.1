Return-Path: <linux-kernel-owner+w=401wt.eu-S1754289AbYATO6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbYATO6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 09:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYATO6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 09:58:42 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:39104 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753282AbYATO6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 09:58:41 -0500
Date: Sun, 20 Jan 2008 20:28:44 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrea Righi <righiandr@users.sourceforge.net>,
       Naveen Gupta <ngupta@google.com>, Paul Menage <menage@google.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
Message-ID: <20080120145844.GN8973@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Andrea Righi <righiandr@users.sourceforge.net>,
	Naveen Gupta <ngupta@google.com>, Paul Menage <menage@google.com>,
	Dhaval Giani <dhaval@linux.vnet.ibm.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Pavel Emelyanov <xemul@openvz.org>
References: <2846be6b0801181439o55dcff09ted2b8f817e7ba682@mail.gmail.com> <4791DC2C.9090405@users.sourceforge.net> <4793507B.6040706@users.sourceforge.net> <20080120143239.GS6258@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080120143239.GS6258@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe <jens.axboe@oracle.com> [2008-01-20 15:32:40]:

> On Sun, Jan 20 2008, Andrea Righi wrote:
> Your approach is totally flawed, imho. For instance, you don't want a
> process to be able to dirty memory at foo mb/sec but only actually
> write them out at bar mb/sec.
> 
> The noop-iosched changes are also very buggy. The queue back pointer
> breaks reference counting and the task pointer storage assumes the task
> will also always be around. That's of course not the case.
> 
> IOW, you are doing this at the wrong level.

Andrea, Some of the problems pointed out so far have been solved in
the IO controller from OpenVZ (cc'ing Pavel for inputs).

> 
> What problem are you trying to solve?
> 
> -- 
> Jens Axboe
> 

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
