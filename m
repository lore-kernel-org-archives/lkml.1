Return-Path: <linux-kernel-owner+w=401wt.eu-S1763751AbYCGNJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763751AbYCGNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 08:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757521AbYCGNJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 08:09:50 -0500
Received: from smtp-out.google.com ([216.239.45.13]:11071 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbYCGNJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 08:09:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=PAplR5apq+VeIPktO2NxRykN8AAWkcWwSpVtiPTZknLeAg9kP1TArY+9RbDWt72x/
	HtqxsGfGbt/25/ip0vdLw==
Message-ID: <6599ad830803070509v1ec83aeet9f63bfd61a00ef19@mail.gmail.com>
Date: Fri, 7 Mar 2008 05:09:32 -0800
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot time (v2)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47D13BF1.1060009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080307085735.25567.314.sendpatchset@localhost.localdomain>
	 <6599ad830803070125o1ebfd7d1r728cdadf726ecbe2@mail.gmail.com>
	 <6599ad830803070426l22d78446t588691dedeeb490b@mail.gmail.com>
	 <47D13BF1.1060009@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2008 at 4:58 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  > Or rather, it's the other way around - cgroup_disable=cpuset will
>  > instead disable the "cpu" subsystem if "cpu" comes before "cpuset" in
>  > the subsystem list.
>  >
>
>  Would it? I must be missing something, since we do a strncmp with ss->name.
>  I would expect that to match whole strings.
>

No, strncmp only checks the first n characters - so in that case,
you'd be checking for !strncmp("cpuset", "cpu", 3), which will return
true

Paul
