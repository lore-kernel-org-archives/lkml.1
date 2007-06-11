Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbXFKUyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbXFKUyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbXFKUxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:53:55 -0400
Received: from smtp-out.google.com ([216.239.33.17]:15151 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbXFKUxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:53:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=xjub1jiBR5czWXZ1LGEcQV7WXCJcXXb8s4xlftvS45s2eeVqoSXsORzxdh8biAKnr
	AMygO7WfNENUTQWC9+RdA==
Message-ID: <b040c32a0706111353x7ec86054x8656bbdde02adc47@mail.gmail.com>
Date: Mon, 11 Jun 2007 13:53:44 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Adam Litke" <aglitke@gmail.com>
Subject: Re: [PATCH] shm: Fix the filename of hugetlb sysv shared memory
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       "Albert Cahalan" <acahalan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org,
       "Badari Pulavarty" <pbadari@us.ibm.com>
In-Reply-To: <a0a62dfc0706111200x4c23c285tfa9aebc304a9f3e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com>
	 <20070606204432.b670a7b1.akpm@linux-foundation.org>
	 <787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com>
	 <20070607162004.GA27802@vino.hallyn.com>
	 <m1ir9zrtwe.fsf@ebiederm.dsl.xmission.com>
	 <46697EDA.9000209@us.ibm.com>
	 <m1vedyqaft.fsf_-_@ebiederm.dsl.xmission.com>
	 <a0a62dfc0706111200x4c23c285tfa9aebc304a9f3e6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Adam Litke <aglitke@gmail.com> wrote:
> On 6/8/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > -struct file *hugetlb_zero_setup(size_t size)
> > +struct file *hugetlb_file_setup(const char *name, size_t size)
>
> The bulk of this patch seems to handle renaming this function.  Is
> that really necessary?

It looks OK to me though, because the argument list to that function
is changed.  Avoid change the function name isn't going to reduce the
patch size either.  So we might just change the name as well to match
the function name shmem_file_setup().
