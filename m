Return-Path: <linux-kernel-owner+w=401wt.eu-S933532AbXCFAE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbXCFAE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbXCFAE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:04:27 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:49749 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933565AbXCFAE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:04:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Yw4C3jL/pNBffcYkW3znaOk2NrEZmlbvW790J3ErT+cpo4C9yHGGISBgqj17mgQvQc8D5BXj7TG4ICeWzaNYidIdExc9NCdzxPvsux8ZFpjSTKQJVYu5gcdzHwwwC0L4eUscAcvzKeNiw14GtpnCvbiFDfQe9FYnJUSFu7TE6ms=
Message-ID: <9c21eeae0703051604l20a029c3r8cf09d792ba523be@mail.gmail.com>
Date: Mon, 5 Mar 2007 16:04:24 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: PAGE_SIZE Availability Inconsistency
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070305.160303.59493440.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
	 <20070305.160303.59493440.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/5/07, David Miller <davem@davemloft.net> wrote:
> From: "David Brown" <dmlb2000@gmail.com>
> Date: Mon, 5 Mar 2007 15:55:06 -0800
>
> > I'm kinda wondering how I'm supposed to write portable user-space code
> > if I want to use the PAGE_SIZE define on different architectures.
>
> Call getpagesize().
>

Thanks, but that still leaves PAGE_SIZE available for some
architectures and not for others shouldn't this be moved inside
__KERNEL__ in i386 and x86_64 then?

- David Brown
