Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0BUA6P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 19:58:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:4589 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab0BUA6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 19:58:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=a9rCp3+e8NudWXg2QJH/tACmyn0ZPGSzRWRC+TD8fxsz04n938UOu9ITg9UZHL3W5
	y22hiv5btZHD3KucXf9QQ==
Date: Sat, 20 Feb 2010 16:58:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Young <hidave.darkstar@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] sysctl extern cleanup - mm
In-Reply-To: <20100220141241.GE3195@darkstar>
Message-ID: <alpine.DEB.2.00.1002201657020.20140@chino.kir.corp.google.com>
References: <20100220141241.GE3195@darkstar>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Feb 2010, Dave Young wrote:

> Extern declarations in sysctl.c should be move to their own head file,
> and then include them in relavant .c files.
> 
> Move min_free_kbytes extern declaration to linux/mm.h
> 

It should be moved to include/linux/mmzone.h, that's where the sysctl 
handler is declared.
