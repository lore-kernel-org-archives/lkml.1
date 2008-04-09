Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbYDIRjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbYDIRjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754229AbYDIRjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:39:46 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:24964 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbYDIRjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tYX5JYhGiHghA9Afnf4b0hTcvBdtEBZaAApJPmv/cOpvaJQQs5Pm/V5nL/b6HyKKgUPC0y7oclOKQLrU4NSw7s6W3WslrNlyf3uGl4H98PmxO6KzZ2tP7ppRsFm0t2JNCyZBFXJ6uSc9egne6XflpiZmp+6e2Y5WM6PHIPt36dA=
Message-ID: <36ca99e90804091039v6e1ad966yd738ed88b267f315@mail.gmail.com>
Date: Wed, 9 Apr 2008 19:39:43 +0200
From: "Bert Wesarg" <bert.wesarg@googlemail.com>
To: "Mike Travis" <travis@sgi.com>
Subject: Re: [PATCH 3/3] cpumask: add show cpu map functions v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Paul Jackson" <pj@sgi.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <47FBDB0D.1010202@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	 <20080408184302.113424000@polaris-admin.engr.sgi.com>
	 <36ca99e90804081232iff9b19fp41e76c04cf140446@mail.gmail.com>
	 <47FBDB0D.1010202@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 10:52 PM, Mike Travis <travis@sgi.com> wrote:
>
> Bert Wesarg wrote:
>  > On Tue, Apr 8, 2008 at 8:43 PM, Mike Travis <travis@sgi.com> wrote:
>  >>   * Add cpu_sysdev_class functions to display the following maps
>  >>     with cpulist_scnprintf().
>  >>
>  > Could we add a cpumap_scnprintf() attribute too, just for consistency?
>  >
>  > Bert
>
>  Sure, I could add it.  But by not having it, the user is forced to
>  actually read libbitmask(3) to see a different way of parsing the
>  output, perhaps weaning them off of cpumask_scnprintf()... ;-)
>
>  Do you mind if I add them as:
>
>         /sys/devices/system/cpu/online_map
>         /sys/devices/system/cpu/possible_map
>         /sys/devices/system/cpu/present_map
>         /sys/devices/system/cpu/system_map
Please go ahead.

Bert

PS: this is the only source I found for the libbitmask(3):

ftp://ftp.cvut.cz/kernel/people/christoph/pmig/ray-mmigrate/

but I suspect there is a more official place for this.

>
>  Thanks,
>  Mike
>
