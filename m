Return-Path: <linux-kernel-owner+w=401wt.eu-S1751380AbXCOKWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbXCOKWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 06:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbXCOKWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 06:22:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:27768 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbXCOKWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 06:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=n5jRE3HY4qUL/QHbj4a2ED/B70EWwv/oQYLYhtbN5Bm5a/GEavZasS1fW/OWZIsha0I9PQuw1X7mHgPQYwWSDnE2HaWpOeoLyFtR3axHpVQTVNXyNJst9ajCcMm2xpmJGzS2vG0uAQPnW2ZD4PeKqS7EzXjvRQzDziH2Db9aO1U=
Message-ID: <3ae72650703150322h10882044nbcfdddd4187d31ce@mail.gmail.com>
Date: Thu, 15 Mar 2007 11:22:52 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH] Remove "decl_subsys_name" macro and single usage of it.
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <Pine.LNX.4.64.0703011205510.20928@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703011205510.20928@CPE00045a9c397f-CM001225dbafb6>
X-Google-Sender-Auth: 907f1c504ce4972a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>
>   Remove the macro "decl_subsys_name" which can be used to declare a
> sysfs subsystem, along with the single invocation of it in the source
> tree, since there appears to be little value in creating a subsystem
> whose subsystem name differs from its structure name.  Everyone else
> just uses "decl_subsys".

Sometimes you want shorter variable names as the created objects in
sysfs, because the 80 columns limit of the kernel source makes long
variable names pretty inconvenient.
And all these decl_* macros, obviously can't create any names that
contain '-', which is pretty annoying. There is also a user in the
experimental patches in Greg's tree. Please leave it there for now.

Thanks,
Kay
