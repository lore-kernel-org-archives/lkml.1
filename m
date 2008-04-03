Return-Path: <linux-kernel-owner+w=401wt.eu-S932439AbYDCRSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439AbYDCRSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 13:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759010AbYDCRSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 13:18:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:36583 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759780AbYDCRSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 13:18:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Yj+PJDuLe5DDtrWDUtRJpL+zyzIka2Q3a1BCXd65TxUI1gzRcPWd16eXnIlVy5Jtc
	Z53sV/y3hmiwSrvpUCZ0w==
Message-ID: <6599ad830804031017m60dc5ca5sebaa434e5bde8633@mail.gmail.com>
Date: Thu, 3 Apr 2008 10:17:44 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Add an owner to the mm_struct (v6)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F5109D.8060606@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080403073043.3563.63717.sendpatchset@localhost.localdomain>
	 <6599ad830804030845m71d56d88u3508a252fc134ba5@mail.gmail.com>
	 <47F5109D.8060606@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 10:15 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  > Even better, maybe just pass in the relevant cgroup_subsys_state
>  > objects here, rather than the cgroup objects?
>  >
>
>  Is that better than passing the cgroups? All the callbacks I see usually pass
>  either task_struct or cgroup. Won't it be better, consistent use of API to pass
>  either of those?

I have a long term plan to try to divorce the subsystems from having
to worry too much about actual control groups where possible.

But I guess that for consistency with the current API, passing in the
cgroup is OK.

Paul
