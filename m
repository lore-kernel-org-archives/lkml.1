Return-Path: <linux-kernel-owner+w=401wt.eu-S965651AbXFFW6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965651AbXFFW6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 18:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965631AbXFFW6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 18:58:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:9126 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965611AbXFFW6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 18:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ivtczFELpLbMSfmbQIJQeoBPI3WWI1PAZEskNtj7ytDYbT/fPl2sLfdZUhwLIwzAz8+uivjI9P7DfCAqRRRWQaE/iyDg//H1ckndhVRroTp5jxmp2XH+dSmX5Kv3N2WJfSttwtlREKJeE8qm1Ec0nGqpbj27xnGxx83QNKq0nsk=
Message-ID: <b93822910706061558j6408c4c5n6f00986667591532@mail.gmail.com>
Date: Thu, 7 Jun 2007 00:58:16 +0200
From: "Stefan Prechtel" <stefan.prechtel@googlemail.com>
To: "Peter Oruba" <peter.oruba@amd.com>
Subject: Re: CPU off-on-off: lost CPU management?
Cc: "Mircea Bardac" <dev.list@mircea.bardac.net>,
       "Linux List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200706061350.25553.peter.oruba@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706051003.29501.peter.oruba@amd.com>
	 <200706051253.01551.dev.list@mircea.bardac.net>
	 <200706051256.49179.dev.list@mircea.bardac.net>
	 <200706061350.25553.peter.oruba@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
This issue is solved with 2.6.22-rc for me. The second core is up with
the same speed as core 1 (Bogomips are the same, too).

- Stefan Prechtel


2007/6/6, Peter Oruba <peter.oruba@amd.com>:
> I'm sorry, I am not able to reproduce this issue (using 2.6.21.3). Everything
> works fine on my Turion laptop. It looks like there is also CPU hotplug
> involved in that issue, since brining cpu1 back on doesn't update siblings
> and cpu_cores in /proc/cpuinfo as well. Can you specify more details about
> the system you are using? Have you tried enabling CONFIG_CPU_FREQ_DEBUG and
> booting with "cpufreq.debug=7"?
>
> Peter Oruba
>
>
