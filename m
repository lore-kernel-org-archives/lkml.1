Return-Path: <linux-kernel-owner+w=401wt.eu-S939273AbXG3Jnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939273AbXG3Jnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932499AbXG3Jnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:43:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933881AbXG3Jnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:43:46 -0400
Message-ID: <46ADB2CA.3070107@kernel.sg>
Date: Mon, 30 Jul 2007 17:43:38 +0800
From: Eugene Teo <eugeneteo@kernel.sg>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/partitions/check.c: add_partition() warning fixes
References: <20070729025339.GB19311@kernel.sg> <20070730110831.68075b30@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070730110831.68075b30@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cornelia,

Cornelia Huck wrote:
> On Sun, 29 Jul 2007 10:53:39 +0800,
> Eugene Teo <eugeneteo@kernel.sg> wrote:
[...]
>> +	return;
>> +
>> +err_out_del_link:
>> +	sysfs_remove_link(&p->kobj, "subsystem");
> 
> You need a remove uevent if you did an add uevent above.
> 
>> +err_out_del_kobj:
>> +	kobject_del(&p->kobj);
>> +err_out:
>> +	kfree(p);
> 
> Please use kobject_put() instead.

Thanks for your feedback.

Eugene
