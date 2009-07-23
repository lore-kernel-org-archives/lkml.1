Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbZGWObi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbZGWObi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 10:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751202AbZGWObi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 10:31:38 -0400
Received: from smtp-out.google.com ([216.239.45.13]:27490 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZGWObh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 10:31:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=NdU9JcGjE/i311KMDuFHg1u/TBAvYQxki9knSfk04SboPPkoa/5LscYmlxVkIhXBG
	I/agaKHoJWnegmxIR9INQ==
MIME-Version: 1.0
In-Reply-To: <4A6806D9.8020004@cn.fujitsu.com>
References: <20090722194644.7481.47805.stgit@menage.mtv.corp.google.com>
	 <20090722195040.7481.44939.stgit@menage.mtv.corp.google.com>
	 <4A6806D9.8020004@cn.fujitsu.com>
Date: Thu, 23 Jul 2009 07:31:34 -0700
Message-ID: <6599ad830907230731v13b18e17vbed373f57f878c85@mail.gmail.com>
Subject: Re: [PATCH 3/4] Add a back-pointer from struct cg_cgroup_link to 
	struct cgroup
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 11:44 PM, Li Zefan<lizf@cn.fujitsu.com> wrote:
>
> I think we need to cgroup_enable_task_cg_lists():
>
>        if (!use_task_css_set_links)
>                cgroup_enable_task_cg_lists();
>
> Otherwise we'll see no tasks when reading this debug file
> if use_task_css_set_links == 0.
>

I think that's OK - the debug file should indicate the state of the
kernel, not alter it. If there are no links, then no links should be
printed.

Paul
