Return-Path: <linux-kernel-owner+w=401wt.eu-S1759390AbZB0UN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759390AbZB0UN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 15:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756484AbZB0UNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 15:13:18 -0500
Received: from smtp-out.google.com ([216.239.33.17]:49795 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbZB0UNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 15:13:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=X/2v48qYPPzP9h5RxzThldEOYKpb1K6dOv7YfsU5ZbBlaz/sNO4VYz9KVR3c/5zLZ
	UgwEbV8F0tIJrUA6XPwzg==
MIME-Version: 1.0
In-Reply-To: <20090227162928.6225fc80.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090227162928.6225fc80.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 27 Feb 2009 12:13:10 -0800
Message-ID: <b040c32a0902271213q3dd1931foc2b955d8a028eb6f@mail.gmail.com>
Subject: Re: [PATCH] change cpuacct usage percpu format v2
From: Ken Chen <kenchen@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>, mingo@elte.hu,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 11:29 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> cpuacct.usage_percpu shows per cpu usage information via cgroupfs.
> It shows all "present" cpus information and "whose information ?"
> is explained just by index of data implicitly.
>
> IIRC, there is physical cpu hotplug system and it can remove
> cpus and change map. Considering a software which records
> this information pediodically(like sar), its better to show id of cpu
> in explict way.

The new format carries a lot of overhead.  I would think user space
software can record /sys/devices/system/cpu/present and use that to
map cpu index.

- Ken
