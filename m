Return-Path: <linux-kernel-owner+w=401wt.eu-S1767695AbXEDFfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767695AbXEDFfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 01:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767691AbXEDFfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 01:35:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5792 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767695AbXEDFfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 01:35:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=frVmzOqyIA0NyKoHhaCZijlIzSlGO2esk8NokNpXbidENDYpuu9ZPtBJ2Epxm4/7l
	hhOzaEGgkRlSDbtXQ6SwA==
Date: Thu, 3 May 2007 22:35:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mm-commits@vger.kernel.org, agl@us.ibm.com,
       hermes@gibson.dropbear.id.au, wli@holomorphy.com, clameter@sgi.com
Subject: Re: + per-cpuset-hugetlb-accounting-and-administration.patch added
 to -mm tree
In-Reply-To: <20070503221206.880b1ec8.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0705032233480.24585@chino.kir.corp.google.com>
References: <200705040104.l4414YFR026322@shell0.pdx.osdl.net>
 <20070503183821.b75e8f57.pj@sgi.com> <b040c32a0705032149t2a380f82t8145c1d0f8f6736@mail.gmail.com>
 <20070503221206.880b1ec8.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Paul Jackson wrote:

>  2) adding two new values, by such names as:
> 
> 	Current_Cpuset_HugePages_Total:    0
> 	Current_Cpuset_HugePages_Free:     0
> 

This information is already exported to userspace through sysfs.  Simply 
grab the N-mems allowed to your task from /proc/pid/status, cat 
/sys/devices/system/node/nodeN/meminfo for each N, and add.
