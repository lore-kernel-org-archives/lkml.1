Return-Path: <linux-kernel-owner+w=401wt.eu-S965309AbXBLSzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965309AbXBLSzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965311AbXBLSzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:55:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:8015 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965309AbXBLSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:55:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n6FVC+xob1L0uOvbBa33YJdEE4vo8qP7WZBTThG1pqZ4/cDEd5sxIbMNFSEQB129VDaGAF6D8aaLwlz4xnKp5j5iyzPJZfTePfCriOLfoGDepimNCUzYPJ8xgWXiqpTM2Z88RVS/2MkOCkaV8bKy5BJsyt3jrcSnBT1FCJf0/wA=
Message-ID: <b6a2187b0702121055q326c748ev7088c4a051e9e617@mail.gmail.com>
Date: Tue, 13 Feb 2007 02:55:38 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [QUESTION] file access time in millisecond?
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200702121056.03467.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0702112327t7294c221w460b3bd0f77d0e@mail.gmail.com>
	 <p73bqjzhhp7.fsf@bingen.suse.de>
	 <b6a2187b0702120152s1279b931x813413a4234d8dec@mail.gmail.com>
	 <200702121056.03467.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/07, Andi Kleen <ak@suse.de> wrote:

> It should be always available in padding, even on older glibc. Given a sufficiently
> new kernel. The bigger problem is getting a file system that supports it.
> Manpages are often outdated.

Andi,

Ok, found it. Thanks. You're right. ext2, reiserfs doesn't support it.
I was trying to get down to find out which file got generated first
and thought stat() would do the job, but didn't realize that it's not
so simply. Oh well.

Thanks,
Jeff.
