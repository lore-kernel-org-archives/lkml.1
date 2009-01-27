Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbZA0HwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbZA0HwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 02:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbZA0HwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 02:52:16 -0500
Received: from smtp-out.google.com ([216.239.33.17]:60582 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZA0HwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 02:52:16 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-gmailtapped-by:x-gmailtapped;
	b=tm5InpCwuF+quw7T1WLY7yPQ4hAaMme6jWghI3/RxAbSFvySk7HdM+XxWRRXTGVtP
	H25x7TxeV0GXVLIEQNaNQ==
Date: Mon, 26 Jan 2009 23:51:27 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, balbir@linux.vnet.ibm.com,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
In-Reply-To: <20090127164238.D479.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com>
References: <20090127155825.D476.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262325320.13157@chino.kir.corp.google.com> <20090127164238.D479.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-GMailtapped-By: 172.24.198.77
X-GMailtapped: rientjes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009, KOSAKI Motohiro wrote:

> Yup, indeed. :)
> honestly, I talked about the same thingk recently "lowmemory android driver not needed?" thread.
> 

Yeah, I proposed /dev/mem_notify being made as a client of cgroups there 
in http://marc.info/?l=linux-kernel&m=123200623628685

How do you replace the oom killer's capability of giving a killed task 
access to memory reserves with TIF_MEMDIE in userspace?
