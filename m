Return-Path: <linux-kernel-owner+w=401wt.eu-S1755579AbXERRaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbXERRaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 13:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXERRaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 13:30:10 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:39744 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXERRaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 13:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ThjFLjVtiTDsMLeynToscjN8yxejJFGdSm1F4e3GAHXJ/JDVJHkAoVwvn9O+2YDVjyGF8CZdony6dyerZXfOZzufPquF9dVDZvCn9UbU6FQUVPMwQaVLBFb2eCvY1kDYzQg3KKIqbrA1P0c0ophB4xBbc9ZIgGzCrLY7oewSxuw=
Message-ID: <86802c440705181030m6d72edf6w87749275c46c7c93@mail.gmail.com>
Date: Fri, 18 May 2007 10:30:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [patch] x86_64, irq: check remote IRR bit before migrating level triggered irq
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, mingo@elte.hu, ak@suse.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Zou, Nanhai" <nanhai.zou@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
In-Reply-To: <m1veeqjitm.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070517230324.GB8089@linux-os.sc.intel.com>
	 <m1ejlf0y96.fsf@ebiederm.dsl.xmission.com>
	 <20070518010119.GB12088@linux-os.sc.intel.com>
	 <m1veeqjitm.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

ioapic_level irq is limited, So if we keep vector number not changed
when imgration to other cpus.  It that could help.

it will need modify a little with assign_irq_vector and
irq_complete_move/smp_irq_move_cleanup_interrupt. because it assume
vector must be changed.

YH
