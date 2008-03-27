Return-Path: <linux-kernel-owner+w=401wt.eu-S1759308AbYC0JtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308AbYC0JtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbYC0Js6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:48:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:19389 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbYC0Js5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Al26mmc07Ckr4RozvMJN02Y6Wj5u7pqInZZ4FH9VmuJDoU3tkWZPpjjRERwoD907GpFBBvg/RvYiBYpfHDvZFbp0tHEhBKR8JDZiZIOlYR7CMwucbhVzhe2VWL1aKrWQaCP5imNjda+O9IkylF/lgJTnDYlWcqfjDXg/4IAnSaY=
Message-ID: <e2e108260803270248w6a9abf42hc68b0b5397543eaf@mail.gmail.com>
Date: Thu, 27 Mar 2008 10:48:55 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Christoph Lameter" <clameter@sgi.com>
Subject: Re: quicklists confuse meminfo
Cc: "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Albert Cahalan" <acahalan@cs.uml.edu>
In-Reply-To: <Pine.LNX.4.64.0803260929350.27909@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
	 <20080309114640.85c9c3eb.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com>
	 <200803111507.20870.nickpiggin@yahoo.com.au>
	 <e2e108260803210552i4cdef6a5qf8f5076eaac2cf03@mail.gmail.com>
	 <20080321144517.GA1545@elte.hu>
	 <e2e108260803260045q37792686l80ddb421f2e67c6f@mail.gmail.com>
	 <20080326081349.GA8159@elte.hu>
	 <e2e108260803260337j4175b3emc3304b67b8314bea@mail.gmail.com>
	 <Pine.LNX.4.64.0803260929350.27909@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 5:34 PM, Christoph Lameter <clameter@sgi.com> wrote:
> On Wed, 26 Mar 2008, Bart Van Assche wrote:
>
>  > Thanks to everyone who worked on this. By the way, I have asked Albert
>  > Calahan, the procps maintainer, to fix the free/top/vmstat tools such
>  > that these take recently added /proc/meminfo fields into account and
>  > display correct values on recent 2.6 kernels. See also
>  > http://bugzilla.kernel.org/show_bug.cgi?id=9991 and
>  > http://marc.info/?l=linux-mm&m=120496901605830&w=2.
>
>  Be aware that some distros have hacked their meminfo (proc and
>  /sys/devices/system/node/node*/meminfo) output to be more compatible with
>  recent 2.6 kernels but not updated to the new ZVC counter scheme. On those
>  kernels (<2.6.17) counters may show weird values and the sum of the per
>  node counters in sysfs may not yield the same amount shown in
>  /proc/meminfo.

In my opinion /proc/meminfo is part of the kernelspace - userspace
API, and any Linux distributor that modifies /proc/meminfo is
responsible for modifying the tools that rely on this information.

Bart.
