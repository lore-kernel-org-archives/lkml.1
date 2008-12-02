Return-Path: <linux-kernel-owner+w=401wt.eu-S1754086AbYLBWQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086AbYLBWQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbYLBWQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:16:34 -0500
Received: from smtp-out.google.com ([216.239.45.13]:27283 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbYLBWQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:16:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=CR+Xo68mA4+/ht5mwBgU1PMDK0fqkPVEoi0t1r4x7OOUe89s9+twrHBUZkq+eXJbm
	9FYfsRsilaDLeSVsTCDkw==
MIME-Version: 1.0
In-Reply-To: <4934A8FB.80904@cn.fujitsu.com>
References: <492FC1C2.9050001@cn.fujitsu.com>
	 <6599ad830812011620ld861aabgc70846a07ce1d487@mail.gmail.com>
	 <4934A8FB.80904@cn.fujitsu.com>
Date: Tue, 2 Dec 2008 14:16:29 -0800
Message-ID: <6599ad830812021416s76e393c8x5e3f5afa1bc370e2@mail.gmail.com>
Subject: Re: [PATCH 3/3] cgroups: introduce link_css_set() to remove duplicate 
	code
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 1, 2008 at 7:18 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
> How about:
>
> /**
>  * link_css_set - a helper function to link a css_set to a cgroup
>  * @ tmp_cg_links: cg_cgroup_link objects allocated by allocate_cg_links()
>  * @ cg: the css_set to be linked
>  * @ cgrp: the destination cgroup
>  */

Sounds good.

>
> Because we are linking all the css_sets to the root cgroup, so I think root_cgrp
> helps readability.
>

But we're creating the hierarchy at this point, so there can clearly
only be one cgroup any (which is the root cgroup).

I don't think it's any more or less readable, it just seems an
unnecessary change.

Paul
