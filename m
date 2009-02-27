Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbZB0Hz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbZB0Hz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 02:55:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZB0HzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 02:55:15 -0500
Received: from smtp-out.google.com ([216.239.33.17]:52245 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZB0HzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 02:55:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=G+KYLIT9HEfANmwzoYeGPaWo350ugAkF9RzIpOHB0OaIF2/C5+2ShF1x44EApNxhC
	wc9QQRUMlyQG2bNxOusuA==
MIME-Version: 1.0
In-Reply-To: <20090227162928.6225fc80.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090227140537.390905c4.kamezawa.hiroyu@jp.fujitsu.com>
	 <20090227162928.6225fc80.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 26 Feb 2009 23:55:06 -0800
Message-ID: <6599ad830902262355i1a5d4040p53ad2274f783b5c0@mail.gmail.com>
Subject: Re: [PATCH] change cpuacct usage percpu format v2
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kenchen@google.com, "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
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
>
> IIRC, there is physical cpu hotplug system and it can remove
> cpus and change map. Considering a software which records
> this information pediodically(like sar), its better to show id of cpu
> in explict way.

Can we just use the read_map() handler for this instead?

Paul
