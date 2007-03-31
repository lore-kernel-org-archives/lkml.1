Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbXCaNwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbXCaNwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 09:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbXCaNwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 09:52:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:26040 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXCaNwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 09:52:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LKeWnlqhE5zaHvuPRijwCt8z4B3b70MfdXuA6LWIBGqUov42KEL9wKJ9GBpeBgiDMo5uXOL/vx760B72jxLy2pWTq9tIb1NdbhNVgSPcsKZef8oh6BYBvEA2eztv+Z6oUI8OWiQeRmULNRAQ6t/K6whNDBI/baMCFtj4dzUJv9Q=
Message-ID: <2375c9f90703310652w284dc313obb579b2b0dc62c76@mail.gmail.com>
Date: Sat, 31 Mar 2007 21:52:30 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: "Pedram M" <pmessri@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: submitting kernel janitorials
In-Reply-To: <9c9aa5d00703310640m6f4cf55aidc3cba706a8d3bff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9c9aa5d00703310627v7688a865p11ea1aa52e249b16@mail.gmail.com>
	 <2375c9f90703310637o38f6c748n835f3b119b0a1c43@mail.gmail.com>
	 <9c9aa5d00703310640m6f4cf55aidc3cba706a8d3bff@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/31, Pedram M <pmessri@gmail.com>:
> Ok thanks,
>
> I've sent one already, could you please double check:
>
> @@ -4590,7 +4590,7 @@
>         printk("stli_findpcibrds()\n");
>  #endif
>
> -       while ((dev = pci_find_device(PCI_VENDOR_ID_STALLION,
> +       while ((dev = pci_get_device(PCI_VENDOR_ID_STALLION,
>             PCI_DEVICE_ID_ECRA, dev))) {
>                 if ((rc = stli_initpcibrd(BRD_ECPPCI, dev)))
>                         return(rc);
>
>
> That as an example for file:
>
> drivers/char/istallion.c
>
>
> Thanks,
> Pedram

Why did you delete the list? Please don't do that.

In fact, I am a newbie too. I know pci_find* functions are deprecated
and gcc will warn that. And I think we should replace them. You can
try to make patches for them and submit them to  Greg. (Greg, is that
OK?)

-- 
So Dark The Con Of Man.
