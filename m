Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbZKXIek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbZKXIek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932241AbZKXIej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:34:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239AbZKXIei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:34:38 -0500
Message-ID: <4B0B9B44.1010206@redhat.com>
Date: Tue, 24 Nov 2009 16:37:24 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Amerigo Wang <amwang@redhat.com>,
       linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@redhat.com>
Subject: Re: [Resend Patch] kexec: allow to shrink reserved memory
References: <20091123093958.4963.38592.sendpatchset@localhost.localdomain> <20091124075813.GA14488@bicker>
In-Reply-To: <20091124075813.GA14488@bicker>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> On Mon, Nov 23, 2009 at 04:37:02AM -0500, Amerigo Wang wrote:
> [snip]
>> +size_t crash_get_memory_size(void);
> [snip]
>> +static ssize_t kexec_crash_size_show(struct kobject *kobj,
>> +				       struct kobj_attribute *attr, char *buf)
>> +{
>> +	return sprintf(buf, "%lu\n", crash_get_memory_size());
>> +}
> 
>   CC      kernel/ksysfs.o
> kernel/ksysfs.c: In function ‘kexec_crash_size_show’:
> kernel/ksysfs.c:106: warning: format ‘%lu’ expects type ‘long unsigned int’, but argument 3 has type ‘size_t’
> 
> Could we get suppress this gcc warning?

Oops! Try to replace '%lu' with '%zu'...

I didn't see this warning, will cook a delta patch.

Thanks!
