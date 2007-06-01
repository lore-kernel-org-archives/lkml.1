Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbXFAGtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbXFAGtU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757449AbXFAGtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:49:04 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:10110 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145AbXFAGtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:49:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Plcii/GX6KjanZAizJNlDADKy6f6UHuignS8ZFvyRetOr+xATYIQcuL+l2eXdhA9c6XCripuvVINv4Wd/vqU2VS9E9h9MT862WaYSpBdOV0aDkazlmggfRShQ0ROoa0/32Diixhy5mA40D73SfDQUK0zdtRQPa6MJaqTRVVqIIo=
Message-ID: <25ae38200705312348r3cd02c90h5080617fa1f0a987@mail.gmail.com>
Date: Fri, 1 Jun 2007 12:18:59 +0530
From: "Anand Jahagirdar" <anandjigar@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: Patch related with Fork Bombing Atack
Cc: security@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070531134611.GZ32105@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <25ae38200705310645n5e913a91weaa14521908f7989@mail.gmail.com>
	 <20070531134611.GZ32105@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, May 31 2007, Anand Jahagirdar wrote:
> > 2) Printk message in my patch will definitely help Administrator/Root
> > User to detect which particular user is trying fork bombing attack on
> > his machine by looking at /var/log/messages or dmesg . he can take
> > action against that particular user and kill his processes.
>
> You just opened a DoS possibility for any user, they can now flood the
> syslog instead.
>
Jens Axboe

     when they try to flood the syslog using fork bombing attack,
their messge will be printed only once in syslog and it will show how
many times it has repeated. due to this he will not able to flood the
syslog.and i am using only one single variable in my printk messge so
it is quite not possible to flood the syslog.

   am i missing something??

anand
> --
>
>
>
