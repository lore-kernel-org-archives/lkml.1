Return-Path: <linux-kernel-owner+w=401wt.eu-S1764216AbYBTCwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764216AbYBTCwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 21:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbYBTCvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 21:51:55 -0500
Received: from smtp-out.google.com ([216.239.33.17]:10057 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451AbYBTCvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 21:51:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hoEvk+F80KWj94LWfo8FYiwswF1XhY1pFGZgrj7jA1S+F/2B/q82qg1+jgYQd4iQl
	Hbs27uxUlG32+CE3tbmmQ==
Message-ID: <6599ad830802191851ndfbc667oecb56492e87cd782@mail.gmail.com>
Date: Tue, 19 Feb 2008 18:51:43 -0800
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [RFC][PATCH 1/7] CGroup API: Add cgroup.api control file
Cc: balbir@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com,
       "Pavel Emelianov" <xemul@openvz.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <47B953A8.9030206@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080215204418.535025000@menage.corp.google.com>
	 <20080215204820.734926000@menage.corp.google.com>
	 <47B6B5CA.7040201@linux.vnet.ibm.com>
	 <6599ad830802160944v6d529570k1ade6df273ca3d0d@mail.gmail.com>
	 <47B953A8.9030206@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2008 1:45 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> >
>
> But we don't have /proc/proc.api or /sys/sysfs.api ...

True. And /proc is a bit of a mess. Having a similar API file for
sysfs sounds like a good idea to me.

>
> And is it better to describe the debug subsystem too?
>

Yes, probably, but that would be a separate patch to the debug
subsystem itself, not the main cgroups code.

Paul
