Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbYAaARg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbYAaARg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756073AbYAaARZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:17:25 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:17976 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997AbYAaARY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:17:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GDfnRCMU2ooB3ioR17AcG00wuiOZfqz5Ou7UJhRQ2ZpmDWoIBZVLTyjGg3ZKylKjXG1D/4emhZfFNMJVwQD8Dc2W/sVEdf4+rByonaYvS/5EVhys79KaYfFRCr6nRWHOVNFH2LLNSQO+be9BMlXN91FZQUWDtfKFZrt+DIciLXc=
Message-ID: <649aecc70801301617m6331bcb8i8ce60366e182c739@mail.gmail.com>
Date: Wed, 30 Jan 2008 19:17:20 -0500
From: "SANGTAE HA" <sangtae.ha@gmail.com>
To: "Bruce Allen" <ballen@gravity.phys.uwm.edu>
Subject: Re: e1000 full-duplex TCP performance well below wire speed
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.63.0801301610240.19938@trinity.phys.uwm.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.63.0801300324000.6391@trinity.phys.uwm.edu>
	 <20080130.055333.192844925.davem@davemloft.net>
	 <Pine.LNX.4.63.0801300758020.11487@trinity.phys.uwm.edu>
	 <20080130082136.1017631d@deepthought>
	 <Pine.LNX.4.63.0801301610240.19938@trinity.phys.uwm.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruce,

On Jan 30, 2008 5:25 PM, Bruce Allen <ballen@gravity.phys.uwm.edu> wrote:
>
> In our application (cluster computing) we use a very tightly coupled
> high-speed low-latency network.  There is no 'wide area traffic'.  So it's
> hard for me to understand why any networking components or software layers
> should take more than milliseconds to ramp up or back off in speed.
> Perhaps we should be asking for a TCP congestion avoidance algorithm which
> is designed for a data center environment where there are very few hops
> and typical packet delivery times are tens or hundreds of microseconds.
> It's very different than delivering data thousands of km across a WAN.
>

If your network latency is low, regardless of type of protocols should
give you more than 900Mbps. I can guess the RTT of two machines is
less than 4ms in your case and I remember the throughputs of all
high-speed protocols (including tcp-reno) were more than 900Mbps with
4ms RTT. So, my question which kernel version did you use with your
broadcomm NIC and got more than 900Mbps?

I have two machines connected by a gig switch and I can see what
happens in my environment. Could you post what parameters did you use
for netperf testing?
and also if you set any parameters for your testing, please post them
here so that I can see that happens to me as well.

Regards,
Sangtae
