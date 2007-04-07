Return-Path: <linux-kernel-owner+w=401wt.eu-S964930AbXDGB62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964930AbXDGB62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 21:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964989AbXDGB62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 21:58:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:34877 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964930AbXDGB60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 21:58:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=s5UlahQxg0XcDgQ+1jUPV07HV/4r71T8a2KqmDRyYwa+Mg304L9mxzFTWXHh8XBJH
	d2hvSLa/jhpZLCKMQoqeQ==
Message-ID: <6599ad830704061858j30747a79rd16b20a23d8584ab@mail.gmail.com>
Date: Fri, 6 Apr 2007 18:58:15 -0700
From: "Paul Menage" <menage@google.com>
To: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com
Subject: Re: [ckrm-tech] [PATCH 3/7] Containers (V8): Add generic multi-subsystem API to containers
Cc: ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, containers@lists.osdl.org,
       devel@openvz.org
In-Reply-To: <20070407001324.271959000@menage.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070406233221.989528000@menage.corp.google.com>
	 <20070407001324.271959000@menage.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/6/07, menage@google.com <menage@google.com> wrote:
> This patch removes all cpuset-specific knowlege from the container
> system, replacing it with a generic API that can be used by multiple
> subsystems. Cpusets is adapted to be a container subsystem.
>
> +
> +       /* Set of subsystem states, one for each subsystem. NULL for
> +        * subsystems that aren't part of this hierarchy. These
> +        * pointers reduce the number of dereferences required to get
> +        * from a task to its state for a given container, but result
> +        * in increased space usage if tasks are in wildly different
> +        * groupings across different hierarchies. This array is
> +        * mostly immutable after creation - a newly registered
> +        * subsystem can result in a pointer in this array
> +        * transitioning from NULL to non-NULL */
> +       struct container_subsys_state *subsys[CONTAINER_SUBSYS_COUNT];

Oops, this comment is rather out of date and should have been trimmed
for this patch. It should be disregarded apart from the first
sentence.

Paul
