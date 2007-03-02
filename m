Return-Path: <linux-kernel-owner+w=401wt.eu-S2992515AbXCBP30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992515AbXCBP30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992519AbXCBP30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:29:26 -0500
Received: from nz-out-0506.google.com ([64.233.162.232]:2144 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992515AbXCBP3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:29:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JX4uWXXWMj9uVRaX0yys2SJqllfUIuNISVMZjY4A/WpcSiN70zJegmQP9xKEl/eU03vd8WFMw63ziVkx/D/NmFqm7yaaxwFUTLJ10HUKn542QuMhYuoI811+4aTrh2gs9R0Ic45YwEd22C5TbLlWksz05ajpYZMkt2AoViGRYQM=
Message-ID: <a36005b50703020729m75ad7581lb75701ae121462d9@mail.gmail.com>
Date: Fri, 2 Mar 2007 07:29:23 -0800
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: [RFC] Heads up on sys_fallocate()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Badari Pulavarty" <pbadari@us.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
       alex@clusterfs.com, suzuki@in.ibm.com
In-Reply-To: <1172841831.7992.14.camel@kleikamp.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	 <20070225022326.137b4875.akpm@linux-foundation.org>
	 <20070301183445.GA7911@amitarora.in.ibm.com>
	 <45E7BE4B.5070602@us.ibm.com>
	 <20070301221652.2aa3e973.akpm@linux-foundation.org>
	 <1172841831.7992.14.camel@kleikamp.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/2/07, Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
> Then there's no need for sys_allocate to return a long.

Every syscall must return a long.  Otherwise you can have problems on
64-bit archs.
