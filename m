Return-Path: <linux-kernel-owner+w=401wt.eu-S1423013AbXCIAr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423013AbXCIAr7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423015AbXCIAr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:47:58 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:41107 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423013AbXCIAr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:47:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ci6IbyVq0n7NKsDVaW1KyQkFrnlz02YLKD6IfggQ+sHFI0mL+6DCiwl3qP/PqghARiUy34V8W+50ia2ThPnnVp8c0PO5agExD8wqvdK/cd7GAWhnNG59xWKDOvXg5gzL3IqpWDF8iuE2KRmmYhwjJW5q8ybge9uHWPMiPkuyeng=
Message-ID: <9c21eeae0703081647u4c203fa8re315e07467c563fe@mail.gmail.com>
Date: Thu, 8 Mar 2007 16:47:54 -0800
From: "David Brown" <dmlb2000@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: KVM and rtc missing interupts 2.6.21-rc3
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <adatzwvxuta.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c21eeae0703081348i713c996bked9ebe2af76bc2db@mail.gmail.com>
	 <adatzwvxuta.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I started to debug this a little while ago but I never got too far.
> However it doesn't seem connected with kvm -- it is something to do
> with tun/tap or bridging holding a lock too long I think.
>
> Try running your guest with -no-kvm (and even with the kvm module not
> loaded, just to be sure).  In my case I still saw the messages.
> However, removing the "-net tap" line from my command line did get rid
> of the messages.

Hmmm I'm getting the same thing on 2.6.20.1 as well.

- David Brown
