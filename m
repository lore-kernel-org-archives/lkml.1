Return-Path: <linux-kernel-owner+w=401wt.eu-S1758206AbYDJRYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbYDJRYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 13:24:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758012AbYDJRYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 13:24:39 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:40833 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbYDJRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 13:24:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wZYGxHCV+6YflxXFowO4rvtkrrvOIuVNwzULtw+MGnK5e0jNFD9WHdgQ1V9HhOvr//0BwGUepsGubk1kTAYH7oC7rKZwEsXvT5DBt7fvTtG2Gyw1rQh1A25dz/TOdWw66IQw9CiHSmmIjJc4pLATvwp61a3giB83x7MdMQM9G4Q=
Message-ID: <36ca99e90804101024y1f159b08ucaa52eab0bea6b88@mail.gmail.com>
Date: Thu, 10 Apr 2008 19:24:37 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 1/3] x86: modify show_shared_cpu_map in intel_cacheinfo v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47FBD915.7020809@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	 <20080408184301.842103000@polaris-admin.engr.sgi.com>
	 <36ca99e90804081236ifa3eecfue3dd211f9cdcb32a@mail.gmail.com>
	 <47FBD915.7020809@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 10:44 PM, Mike Travis <travis@sgi.com> wrote:
>  Btw, you were asking about how to determine NR_CPUS.  Here's one way:
>
>  root@newton:~# cat /sys/devices/system/cpu/online
>  0-2,4-7
>  root@newton:~# cat /sys/devices/system/cpu/possible
>  0-511
>  root@newton:~# cat /sys/devices/system/cpu/present
>  0-7
>  root@newton:~# cat /sys/devices/system/cpu/system
>  0-4095
I think its easier to count the commas from a cpumask file. Here you
must parse a complete list expression, just to get the max id.

Either way, I think this isn't a very clean way.

Bert
>  Thanks,
>  Mike
>
