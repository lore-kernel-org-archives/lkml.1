Return-Path: <linux-kernel-owner+w=401wt.eu-S1945945AbXC3Ej2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945945AbXC3Ej2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 00:39:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945946AbXC3Ej2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 00:39:28 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:16476 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945945AbXC3Ej0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 00:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=af6cUn29814RhKXBAgh05G9QFwP+/7mnEPdGvRfM7qqUYTgeOB2DEM7dB3rkMG/l5GV5MjtkhgtXVcPATAFEkSWYBDzkJCdBr33uAO/qv/3cBHmBmywiQs0FUKVZ2StNW12WZZus6pf/NhZdRDRRDN0+BJcHjxXweojbCyzoq1g=
Message-ID: <75b66ecd0703292139m371e023xc17b3124ef991919@mail.gmail.com>
Date: Fri, 30 Mar 2007 00:39:23 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Elliott Johnson" <ejohnson@linuxmail.org>
Subject: Re: strange high system cpu usage.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070330035457.57A4124753@ws5-3.us4.outblaze.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070330035457.57A4124753@ws5-3.us4.outblaze.com>
X-Google-Sender-Auth: eca43daf6f0be0c4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/29/07, Elliott Johnson <ejohnson@linuxmail.org> wrote:
> >What problem are you trying to solve?  IOW, how do you know it's not
> >just an artifact of diferent load average calculation between 2.4 and
> >2.6?
> >
> >Are you actually seeing reduced throughput/performance?  Or are you
> >just looking at load average?
> >
> >Lee
>
> Well the problem is apparent, we are having abnormally high cpu usage.  It's about a
> 20-40% performance hit.
>

Please post a kernel profile for the problematic workload with the
"good" and "bad" kernels (search the list archive for Andrew Morton's
instructions on doing it with oprofile, email me privately if you
can't find it).

> The vmstat man page has little information on this statistic and there seems to be varying
> explanations on the web.  I was hoping for a decisive explanation (or link) and possibly
> advice in toggling this value (or reasons not to).

The meaning of these numbers can change drastically from one minor
release to the next, and the docs often lag behind the code.

I would not focus on tweaking VM knobs, but on describing the problem
in enough detail to fix the kernel - it's a bug if the same workload
regresses significantly from one release to another.

Lee
