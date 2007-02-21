Return-Path: <linux-kernel-owner+w=401wt.eu-S1422739AbXBUSEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422739AbXBUSEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422743AbXBUSEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:04:24 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:7337 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422739AbXBUSEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:04:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RSTMD17gktp4oL8PQPNsBk8poT/EYGIlGQ0jiraVHgx4bNaN+fSYR1dmeuGTEeWck/YbG1iYStG63JOpVBaUaA64BPRMpRNEwwzDB1mDMu+MCx3Krxb2MZ6P/H/1vKrDr/Uov/sqtCGOTXFTMURYIWxlFcTUVy2zIo12oO9jnV8=
Message-ID: <75b66ecd0702211004x49c4613cqe26d4871ec1453e8@mail.gmail.com>
Date: Wed, 21 Feb 2007 13:04:12 -0500
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Matthew Fredrickson" <creslin@digium.com>
Subject: Re: High CPU usage with sata_nv
Cc: "Robert Hancock" <hancockr@shaw.ca>, "Tejun Heo" <htejun@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <0c69abe94bbc69f652831a64ad77d0cb@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.1OWRIIUBXsZOXflsGLA+7d4YCc0@ifi.uio.no>
	 <fa.A0XBTh7eCfsh11d3AhMO71/4xQU@ifi.uio.no>
	 <fa.fCm35VohC2wt9vlkg94Ru7me4ic@ifi.uio.no>
	 <fa.qDqCne4pXntL0PolSS2j8t4py3g@ifi.uio.no>
	 <fa.8TboLRab6f7zzIWFr/JPM6q04Zo@ifi.uio.no>
	 <fa.PMqnzxUBiShkWV4h9SiztNIwYc0@ifi.uio.no> <45DBBFE8.5080901@shaw.ca>
	 <0c69abe94bbc69f652831a64ad77d0cb@digium.com>
X-Google-Sender-Auth: dafe687e11a79552
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/21/07, Matthew Fredrickson <creslin@digium.com> wrote:
> It's a 2.6.18 kernel.  What we're seeing (by means of the interrupt pin
> on another card) is extremely large interrupt latency (measured from
> the time the interrupt pin goes low to the first couple lines of code
> in the IRQ handler to clear it) occasionally, in the order of 500-700
> microseconds.  I figured it was some other driver on the system
> disabling irqs for a long period of time, but it's difficult to trace
> what might be doing that.

Apply the -rt kernel patch and enable the latency tracer, it will tell
you what code path is responsible.

Lee
