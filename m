Return-Path: <linux-kernel-owner+w=401wt.eu-S1751567AbXBAE2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbXBAE2K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 23:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161167AbXBAE2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 23:28:09 -0500
Received: from wx-out-0506.google.com ([66.249.82.230]:31318 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbXBAE2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 23:28:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jPS4pVSWMC33B48spE5DaJ35okjnNKpZ5nZAtq9QyWmJz8jQ0VY3uoKFd1Dr+XsAaTOFq7EpzeOQC6yhEeaos++VDZELjTcpWnXsgDF1fxV1mqr+cBBdFaL4VNH7JwVFP+WYrxCiIvoCE8A1J1PZE6rhZt2woFzf6GYgGFjSATM=
Message-ID: <75b66ecd0701312028w7866c608hbf70593055c92b19@mail.gmail.com>
Date: Wed, 31 Jan 2007 23:28:07 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha release.
Cc: linux-kernel@vger.kernel.org, libc-hacker@sources.redhat.com,
       libc-alpha@sources.redhat.com
In-Reply-To: <20070129145227.GA10524@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070129145227.GA10524@2ka.mipt.ru>
X-Google-Sender-Auth: 6b6cdfa757020519
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/29/07, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 1. Scheduling fairness.
> Since kernel does not know about multiple threads behind given process,
> it can not add it appropriate number of timeslices for execution.
> Can be solved either by more tight collaboarion of the userspace and
> kernelspace schedulers or simply by increasing process' nice value.

nice value is only meaningful for SCHED_OTHER.  How will you handle a
multithreaded realtime application that uses SCHED_OTHER as well as
SCHED_FIFO threads?

Lee
