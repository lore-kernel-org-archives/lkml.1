Return-Path: <linux-kernel-owner+w=401wt.eu-S1760778AbYARMg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778AbYARMg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbYARMgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:36:19 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:40921 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbYARMgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:36:18 -0500
Date: Fri, 18 Jan 2008 18:06:05 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Andrea Righi <righiandr@users.sourceforge.net>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: limit block I/O bandwidth
Message-ID: <20080118123605.GB14339@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <4790904F.5000101@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4790904F.5000101@users.sourceforge.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 12:41:03PM +0100, Andrea Righi wrote:
> Allow to limit the block I/O bandwidth for specific process containers
> (cgroups) imposing additional delays on I/O requests for those processes
> that exceed the limits defined in the control group filesystem.
> 
> Example:
>   # mkdir /dev/cgroup
>   # mount -t cgroup -oio-throttle io-throttle /dev/cgroup

Just a minor nit, can't we name it as io, keeping in mind that other
controllers are known as cpu and memory?

Will try it out and give some more feedback.

Thanks,
-- 
regards,
Dhaval
