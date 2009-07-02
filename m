Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbZGBCw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbZGBCw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 22:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753057AbZGBCwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 22:52:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25599 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbZGBCwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 22:52:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=pYI0MWtyOEx0raRyMOII9+2NaI1BK/5961PHY0MsQRkEYlvc6TmGylfTNNUqZEwI4
	TZAGDvM2ZfWGCbjXfsO9Q==
MIME-Version: 1.0
In-Reply-To: <20090702114555.b7253edf.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	 <20090702021128.14469.3360.stgit@menage.mtv.corp.google.com>
	 <20090702114555.b7253edf.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 1 Jul 2009 19:52:16 -0700
Message-ID: <6599ad830907011952t2e698e77j1e8dba21402bc9a9@mail.gmail.com>
Subject: Re: [PATCH 7/9] [RFC] Support multiply-bindable cgroup subsystems
From: Paul Menage <menage@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 1, 2009 at 7:45 PM, KAMEZAWA
Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> - in the current version of this patch, mounting a cgroups hierarchy
>>   with no options does *not* get you any of the multi-bindable
>>   subsystems; possibly for consistency it should give you all of the
>>   multi-bindable subsystems as well as all of the single-bindable
>>   subsystems.
>>
> I don't think this is a big problem. Hmm, I wonder there are no people who
> uses cgroup without any options (= mounts all subsys at once)...

In practice I suspect that it's a rare usage outside of manual
playing/testing - any real production system is going to want to be
aware of what subsystems are available and decide which to mount on
each hierarchy.

>
> Wow...seems complicated. How about adding linux/cgroup_multisubsys.h ?

I think that the readability benefits in cgroup.c would be outweighed
by having two different subsys include files.

Paul
