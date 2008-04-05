Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYDETPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYDETPg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 15:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753262AbYDETP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 15:15:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:45768 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871AbYDETPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 15:15:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=oE9aJbYBHTju2patO0k2avN+MHg4HfYMIosy/qcapCWudM3pDpCex0jXTZpzglj0LKfWyDbcAfpD37GAE58fXutowzz1cczexNOURME2EApy+/RLYS/AICn+dzSClZ+tt+q+PbMHFmzQIfCQiWVobEHXhs3DBSwY7kfxEFBO20c=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC][-mm] [1/2] Simple stats for cpu resource controller
Date: Sun, 6 Apr 2008 00:39:02 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: linux-kernel@vger.kernel.org, containers@lists.osdl.org, menage@google.com,
       a.p.zijlstra@chello.nl, balbir@in.ibm.com, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <200804052339.46632.balajirrao@gmail.com> <20080405185616.GA21279@linux.vnet.ibm.com>
In-Reply-To: <20080405185616.GA21279@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804060039.03083.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 April 2008 12:26:16 am Dhaval Giani wrote:
> On Sat, Apr 05, 2008 at 11:39:46PM +0530, Balaji Rao wrote:
> > This patch implements some trivial statistics for the CPU controller.
> > 
> > As per our current requirements, we have decided to keep the stats tick 
based as opposed to using CFS precise accounting.
> > 
> 
> A quick question? Why? Everywhere in the CFS we use precise accounting,
> (even within the CPU controller). Doesn't make sense using ticks here
> then.
> 
Using CFS precise accounting has a cost (see task_utime and task_stime). 
Currently our requirements don't call for precise statistics.

-- 
regards,
Balaji Rao
Dept. of Mechanical Engineering,
National Institute of Technology Karnataka, India
