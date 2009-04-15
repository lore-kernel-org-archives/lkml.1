Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbZDOHcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbZDOHcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 03:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756671AbZDOHcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 03:32:33 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:48462 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752801AbZDOHcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 03:32:33 -0400
In-Reply-To: <20090415115811.0d609e52.kamezawa.hiroyu@jp.fujitsu.com>
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com> <20090415093555.d84b6655.kamezawa.hiroyu@jp.fujitsu.com> <70C851F4-3BEA-4DF0-943E-4740A2E5A844@embeddedalley.com> <20090415115811.0d609e52.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <B0C7ECF0-ED36-4C45-95F6-37E61EB3F121@embeddedalley.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Content-Transfer-Encoding: 7bit
From: Dan Malek <dan@embeddedalley.com>
Subject: Re: [PATCH] Memory usage limit notification addition to memcg
Date: Wed, 15 Apr 2009 00:32:29 -0700
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 14, 2009, at 7:58 PM, KAMEZAWA Hiroyuki wrote:

> Memory cgroup is a feature both for very-small-system and very- 
> large-system.
>
> XXMB(KB) for limit is an idea.
> # echo 100MB > memory.limit_in_bytes.
> # echo 5MB > memory.notify_triger_thresh_in_bytes.
>
> Notify will be generated at 95MB of usage.

I get it, I'll change it.

> The VM monitor application will work like

I see.  Let me finish my patch first, then we
can discuss this some more?

Thanks.

	-- Dan

