Return-Path: <linux-kernel-owner+w=401wt.eu-S1767153AbXEBS3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767153AbXEBS3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767155AbXEBS3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:29:09 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60551 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767153AbXEBS3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:29:08 -0400
Date: Wed, 2 May 2007 11:29:08 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: RE: vmstat: use our own timer events
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F55455F0@scsmsx415.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.64.0705021128340.646@schroedinger.engr.sgi.com>
References: <653FFBB4508B9042B5D43DC9E18836F55455F0@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Pallipadi, Venkatesh wrote:

> Can this use 'deferrable timer' along with round_jiffies. That
> will eliminate the issue of too frequent interrupt when CPU is idle.

Yes I asked Arjan about this.
> >+	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
> >+
> >+	INIT_DELAYED_WORK(vmstat_work, vmstat_update);
> 
> This change alone should help.
> 	INIT_DELAYED_WORK_DEFERRABLE(vmstat_work, vmstat_update);
> 

Hmmm.. I need to check out what this does exactly.

