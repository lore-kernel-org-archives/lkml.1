Return-Path: <linux-kernel-owner+w=401wt.eu-S1755663AbZEKInY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbZEKInY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754865AbZEKInP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:43:15 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5915 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531AbZEKInO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:43:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=QPLfmrjqLh6aMMJ2Lc3e0Rg7UqdnlmhU2AOfjVl1s4kn/VexNML8kG8jDskHhhCJF
	WzdSyeenM6BgObwm+55qQ==
Date: Mon, 11 May 2009 01:43:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hjonnevag <arve@android.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/11 -mmotm] oom: move oom_adj value from task_struct
 to mm_struct
In-Reply-To: <20090511103849.B9BE.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905110141100.24726@chino.kir.corp.google.com>
References: <20090511091640.B9B5.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0905101724400.31823@chino.kir.corp.google.com> <20090511103849.B9BE.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, KOSAKI Motohiro wrote:

> From technical view, your explanation seems good although I haven't
> review your patch.
> but this patch break staging driver rule. I don't like it.
> 
> IOW, if greg pull this patch into his staging tree, it might make
> patch conflict against -mm tree in nearly future.
> 

If I am going to break code that is in mainline (like the Android low 
memory killer is) by moving a member of a data structure, then I'd like to 
provide a fix for it so that it works after my change.  I'll leave the 
merging to Andrew and Greg and if they'd prefer I do this patch in two 
parts, that's fine by me as long as they merge them at the same time.  I 
thought since this code is mainline that it would be easier to go through 
in one series.
