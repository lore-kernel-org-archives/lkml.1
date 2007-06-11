Return-Path: <linux-kernel-owner+w=401wt.eu-S1756948AbXFKTBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948AbXFKTBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753038AbXFKTBC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:01:02 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:2496 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634AbXFKTA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:00:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WQ9umLm3BWz87J07WEeHMwHqT8R8bNADiY8xDqyX/Bk9qdu/f/SNQR5pzC/t46YswGb2PNBtCmHkxbztMUKBcYbqDuvaMEZzGp16VvlyU6Vspun7uNBRkdPllFay2kgdqYxbP4Hc1FDnSwrbaM1XhLcQNL28j5yzSSXvxUFpT0I=
Message-ID: <a0a62dfc0706111200x4c23c285tfa9aebc304a9f3e6@mail.gmail.com>
Date: Mon, 11 Jun 2007 14:00:57 -0500
From: "Adam Litke" <aglitke@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] shm: Fix the filename of hugetlb sysv shared memory
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serge@hallyn.com>,
       "Albert Cahalan" <acahalan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, torvalds@linux-foundation.org,
       "Badari Pulavarty" <pbadari@us.ibm.com>
In-Reply-To: <m1vedyqaft.fsf_-_@ebiederm.dsl.xmission.com>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/8/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> -struct file *hugetlb_zero_setup(size_t size)
> +struct file *hugetlb_file_setup(const char *name, size_t size)

The bulk of this patch seems to handle renaming this function.  Is
that really necessary?

--
Adam Litke ( agl at us.ibm.com )
IBM Linux Technology Center
