Return-Path: <linux-kernel-owner+w=401wt.eu-S932171AbYCGM1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171AbYCGM1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 07:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYCGM1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 07:27:04 -0500
Received: from smtp-out.google.com ([216.239.45.13]:9196 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYCGM1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 07:27:02 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=URDeFe8zhPRTa+mo50oflH5KuOcxEKuGfuWtMN3/m1Bo1vpBU50gOu3LG87Wq4sih
	LPtiIqe7VsvIsZPwvM3Eg==
Message-ID: <6599ad830803070426l22d78446t588691dedeeb490b@mail.gmail.com>
Date: Fri, 7 Mar 2008 04:26:53 -0800
From: "Paul Menage" <menage@google.com>
To: "Balbir Singh" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Add cgroup support for enabling controllers at boot time (v2)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830803070125o1ebfd7d1r728cdadf726ecbe2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080307085735.25567.314.sendpatchset@localhost.localdomain>
	 <6599ad830803070125o1ebfd7d1r728cdadf726ecbe2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 7, 2008 at 1:25 AM, Paul Menage <menage@google.com> wrote:
>
>  Doesn't this mean that cgroup_disable=cpu will disable whichever comes
>  first out of cpuset, cpuacct or cpu in the subsystem list?

Or rather, it's the other way around - cgroup_disable=cpuset will
instead disable the "cpu" subsystem if "cpu" comes before "cpuset" in
the subsystem list.

Paul
