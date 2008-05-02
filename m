Return-Path: <linux-kernel-owner+w=401wt.eu-S935973AbYEBTku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935973AbYEBTku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753173AbYEBTkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:40:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:14063 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758032AbYEBTkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=mf/dqf1ErxUfUQeFflz3XgH11t4l85UD3qURKTyEZBsghj0nrA/qqNYhTLTP7do0MUkp0aiqzFu8/Z28stpNZfoOtpdsTxBEnfCGJ6jwb78d0OilvXnz3R3AqqMH/0mttWmyM/lpvjeiz472OWniDmvp16GqnfjZPhGqcMEKFbM=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology Karnataka
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][-mm] Simple stats for cpu resource controller v3
Date: Sat, 3 May 2008 01:10:28 +0530
User-Agent: KMail/1.9.9
Cc: dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, menage@google.com, balbir@in.ibm.com,
       vatsa@linux.vnet.ibm.com, a.p.zijlstra@chello.nl
References: <200804052339.46632.balajirrao@gmail.com> <200805012311.06797.balajirrao@gmail.com> <20080501140026.6188065e.akpm@linux-foundation.org>
In-Reply-To: <20080501140026.6188065e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805030110.29511.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008 02:30:26 am Andrew Morton wrote:
<snip>

Hi Andrew,

Thank you for the review.
>
> Did you consider using include/linux/percpu_counter.h?
>
> If so, what was wrong with it?
>
> Because it would be much better to fix per-cpu counters than to invent new
> stuff.
No, I hadn't consider using the percpu_counters infrastructure. But today when 
I tried using it, I got an early exception.I guess its because I tried 
calling percpu_counter_init from within sched_init, which I perhaps shouldn't 
do, because percpu_counter_init expects cpu hotplug code to be initialized by 
then. Right ? Correct me if I'm wrong.

How about we start collecting statistics at a later stage i.e, after 
percpu_counter becomes usable ?

-- 
Warm Regards,

Balaji Rao
Dept. of Mechanical Engineering
NITK
