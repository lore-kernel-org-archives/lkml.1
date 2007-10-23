Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXJWQew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXJWQew (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbXJWQep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:34:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:38283 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbXJWQeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:34:44 -0400
Date: Tue, 23 Oct 2007 22:17:04 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] CFS CGroup: Report usage
Message-ID: <20071023164704.GE4667@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <471D4523.4040509@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471D4523.4040509@google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2007 at 05:49:39PM -0700, Paul Menage wrote:
> Report CPU usage in CFS Cgroup directories
> 
> Adds a cpu.usage file to the CFS cgroup that reports CPU usage in
> milliseconds for that cgroup's tasks

It would be nice to split this into user and sys time at some point.
We have also received request to provide idle time for a
container/cgroup. I presume these will need to be provided as additional files
(in addition to cpu.usage that is)?

-- 
Regards,
vatsa
