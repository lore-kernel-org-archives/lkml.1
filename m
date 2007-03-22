Return-Path: <linux-kernel-owner+w=401wt.eu-S933190AbXCVPaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbXCVPaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933192AbXCVPaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:30:21 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:58286 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933190AbXCVPaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=H+sk1F8dIAm8pD/Asn0GhDcr8XLxs2FHsSd5Xs0pGg1VgiMrPJs7p8gF4NcowmxEiq5RVPveGhiuXEiZ/XdFS6uSp11p3qesmre9RgoobSBfcli+bZVf2GiAYrQZ25BJT9h2SPTxpYMmSL4zVUCYiLIiXLOy7J7jQvZ+GgGd9eM=
Message-ID: <75b66ecd0703220830wdb4a612u86c80e71d4918cc4@mail.gmail.com>
Date: Thu, 22 Mar 2007 11:30:18 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Cestonaro, Thilo (external)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
Subject: Re: how can I touch softlockup watchdog on all cpus?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB710B@ABGEX01E.abg.fsc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F2A@ABGEX01E.abg.fsc.net>
	 <20070321164404.GF13218@redhat.com>
	 <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB710B@ABGEX01E.abg.fsc.net>
X-Google-Sender-Auth: 04a6ad566f3ced6c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/07, Cestonaro, Thilo (external)
<Thilo.Cestonaro.external@fujitsu-siemens.com> wrote:
> > You didn't explain _why_ you need to sleep for such a long time,
> > and as you didn't give a pointer to your code, there's not
> > much people can do to recommend changes other than "don't do that".
>
> The code which is executed between the local_irq_disable and enable,
> is just a function call into our companies bios (e.g. for updating itself)
> and the long time is just 15 sec. while the bios has full control and OS is halted.
> So I can't change anything at this point, but I need to fetch the watchdog,
> cause it is not so nice, if there is a big BUG output on console while the
> computer updates it's bios, very trustworthy isn't it :).

Just disable the softlockup watchdog.

Lee
