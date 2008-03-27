Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbYC0OAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbYC0OAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 10:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755648AbYC0OAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 10:00:08 -0400
Received: from smtp-out.google.com ([216.239.33.17]:62914 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbYC0OAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 10:00:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=p1jJyaTeqVMq3OBwE6bwjP2yYhgKVBQXeA2VRC25SgqYlqUsWCCcGIEkUi4NpaTK5
	PeWg2UvHRQ3i4Lqr0N3KA==
Message-ID: <6599ad830803270659s3e23edaava58d7403b7262369@mail.gmail.com>
Date: Thu, 27 Mar 2008 06:59:52 -0700
From: "Paul Menage" <menage@google.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC][0/3] Virtual address space control for cgroups (v2)
Cc: "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>
In-Reply-To: <20080327190323.f55a73e9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326184954.9465.19379.sendpatchset@localhost.localdomain>
	 <6599ad830803261522p45a9daddi8100a0635c21cf7d@mail.gmail.com>
	 <20080327190323.f55a73e9.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 3:03 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>  How about creating "rlimit controller" and expands rlimit to process groups ?
>  I think it's more straightforward to do this.
>

Yes, that could be useful - the only concern that I would have is that
putting all the rlimits in the same subsystem could limit flexibility.

Paul
