Return-Path: <linux-kernel-owner+w=401wt.eu-S933690AbYEVHMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690AbYEVHMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 03:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932623AbYEVHMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 03:12:06 -0400
Received: from smtp-out.google.com ([216.239.33.17]:47179 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbYEVHME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 03:12:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=O6y6dFoDwZE3cYIQymfz5wTNpWN9GG2CdlXoQvq6Ht1ncneekc2vRXK3JPbisOtf7
	J9z/8UdBROGaikYEPsAgw==
Message-ID: <6599ad830805220011u77313ed7s2c0c9d4a658133cc@mail.gmail.com>
Date: Thu, 22 May 2008 00:11:56 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] remove node_ prefix_from ns subsystem
Cc: "Cedric Le Goater" <clg@fr.ibm.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.osdl.org>
In-Reply-To: <20080521220657.12e8e8c9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48344409.9090903@fr.ibm.com>
	 <20080521220657.12e8e8c9.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 10:06 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>> --- 2.6.26-rc2-mm1.orig/kernel/cgroup.c
>> +++ 2.6.26-rc2-mm1/kernel/cgroup.c
>> @@ -2903,7 +2903,7 @@ int cgroup_clone(struct task_struct *tsk
>>       cg = tsk->cgroups;
>>       parent = task_cgroup(tsk, subsys->subsys_id);
>>
>> -     snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "node_%d", tsk->pid);
>> +     snprintf(nodename, MAX_CGROUP_TYPE_NAMELEN, "%d", tsk->pid);
>>
>>       /* Pin the hierarchy */
>>       atomic_inc(&parent->root->sb->s_active);
>
> This is user-visible, isn't it?  Been there since October.  How can we
> safely change it now?

It is user-visible, but I'd be extremely surprised if anyone was
depending on it or even using it at this point.

Paul
