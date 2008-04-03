Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbYDCELG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbYDCELG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 00:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbYDCEKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 00:10:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:27470 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbYDCEKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 00:10:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=X9kxULDAW8d0DIBvaTkpJnw5vBfoRDuot04bFUrP+2GQo+7oT5RM0A2JxcpzTDLkh
	wYTXU0YjBOXcBGnVyj1Nw==
Message-ID: <6599ad830804022110h2090f3efg7c6173df8185679e@mail.gmail.com>
Date: Wed, 2 Apr 2008 21:10:36 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][-mm] Add an owner to the mm_struct (v4)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F4577E.5060905@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401124312.23664.64616.sendpatchset@localhost.localdomain>
	 <47F3D62E.4070808@linux.vnet.ibm.com>
	 <6599ad830804021253y6bf3b37y9bf1167b63c32e70@mail.gmail.com>
	 <47F4577E.5060905@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2008 at 9:05 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>
>  I checked to see that cgroup_exit is called after mm_update_new_owner(). We call
>  mm_update_new_owner() from exit_mm(). I did not check for current->cgroups !=
>  new_owner->cgroups, since I did not want to limit the callbacks.

No cgroup subsystem should be concerned about mm ownership changes
between tasks in the same cgroup. So I think that's a valid and useful
optimization.

Paul
