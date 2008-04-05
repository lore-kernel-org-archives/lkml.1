Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYDEXbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYDEXbu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 19:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbYDEXbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 19:31:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21286 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYDEXbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 19:31:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Q0pU61U1xVg3SrTjq7K1831NWdbfuzrUVocb/QswdAxm98WPBGJ3cXMIZwrwqtCoD
	hCX0bpzhQFGUlQy0GY54g==
Message-ID: <6599ad830804051631g15363456s1952fda0bb4d395d@mail.gmail.com>
Date: Sat, 5 Apr 2008 16:31:27 -0700
From: "Paul Menage" <menage@google.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [-mm] Add an owner to the mm_struct (v8)
Cc: "Pavel Emelianov" <xemul@openvz.org>, "Hugh Dickins" <hugh@veritas.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       "David Rientjes" <rientjes@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47F7CC08.4090209@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080404080544.26313.38199.sendpatchset@localhost.localdomain>
	 <47F5E69C.9@linux.vnet.ibm.com>
	 <6599ad830804040150j4946cf92h886bb26000319f3b@mail.gmail.com>
	 <47F5F3FA.7060709@linux.vnet.ibm.com>
	 <6599ad830804041211r37848a6coaa900d8bdac40fbe@mail.gmail.com>
	 <47F79102.6090406@linux.vnet.ibm.com>
	 <6599ad830804051023v69caa3d4h6e26ccb420bca899@mail.gmail.com>
	 <47F7BB69.3000502@linux.vnet.ibm.com>
	 <6599ad830804051057n2f2802e4w6179f2e108467494@mail.gmail.com>
	 <47F7CC08.4090209@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 5, 2008 at 11:59 AM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>  >>  It's easier to set it up that way. Usually the end user gets the same SLA for
>  >>  memory, CPU and other resources, so it makes sense to bind the controllers together.
>  >>
>  >
>  > True - but in that case why wouldn't they have the same SLA for
>  > virtual address space too?
>  >
>
>  Yes, mostly. That's why I had made the virtual address space patches as a config
>  option on top of the memory controller :)
>

*If* they want to use the virtual address space controller, that is.

By that argument, you should make the memory and cpu controllers the
same controller, since in your scenario they'll usually be used
together..

Paul
