Return-Path: <linux-kernel-owner+w=401wt.eu-S1945941AbXC3FRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945941AbXC3FRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 01:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945942AbXC3FRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 01:17:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:30985 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945941AbXC3FRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 01:17:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iXWQuVHAy9R51oJAapXgwGjrcjJlQKYeqciYONdgY2hNI/2FmwaJ2Wp9NsHRt0Zrb4tui8YDED+5msPfGWHpvq9C1TGW0CEigkXjG5+1b6NkQt1a201CKwz7sBrEsQj2HaOj6naouhr0+8NMnMNvLAYkskNhHD+8YYZMIXOWp7c=
Message-ID: <75b66ecd0703292217p269248e7l9d15c929394751e0@mail.gmail.com>
Date: Fri, 30 Mar 2007 01:17:06 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Russ Meyerriecks" <datachomper@gmail.com>
Subject: Re: Student Project Ideas
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <bc8960410703290304t7ff61205u7110ac33c671fb4d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bc8960410703290304t7ff61205u7110ac33c671fb4d@mail.gmail.com>
X-Google-Sender-Auth: edca0d028038ad43
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Russ Meyerriecks <datachomper@gmail.com> wrote:
> Hi all,
>   I've been hacking on the Linux kernel all semester for my OS:
> Internals class. We are given full autonomy in picking our final
> programming project and I would love for mine to be /useful/ for the
> Linux kernel and not just a theoretical exorcise. If anybody has any
> bug fixes or features maybe they never got around to, and would be
> suitable for this situation, I would love to hear about them.

You could try to get scheduling latency down into the 1-2ms range
without resorting to kernel preemption.  rt_secret_rebuild is the main
problem - it does not take any spinlocks, and is not a hot path, but
runs in softirq context and is thus non-preemptible.  Even if you
don't succeed you'll acquire a deep knowledge of the networking code.

Lee
