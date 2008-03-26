Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbYCZKh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbYCZKh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 06:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbYCZKhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 06:37:14 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:4938 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbYCZKhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 06:37:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OZTpnVI0XorKTGAlRhOPvCZDaV3oJuVuTZ8Zqv2T9qyoy0ZoY/wuRj9ICETlaO0Bfyb2YQKzi+7PaVKVmv4qGPsUgJHJlXtkYH0vlRzZQYVHzsVvUegcPulXpgAHErB7mVs8rbM4OkSCqQkowX7Xvm3W+iHxe/dK5DQoN8tLEBs=
Message-ID: <e2e108260803260337j4175b3emc3304b67b8314bea@mail.gmail.com>
Date: Wed, 26 Mar 2008 11:37:10 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: quicklists confuse meminfo
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080326081349.GA8159@elte.hu>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 9:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Bart Van Assche <bart.vanassche@gmail.com> wrote:
>
>  > This issue is indeed fixed now, thanks (retested with kernel version
>  > 2.6.25-rc6-00333-ga4083c9-dirty). Where can I find the patch that
>  > fixed this issue ? A Google query for the commit ID returned only one
>  > result, and that was an URL that pointed to your e-mail.
>
>  thanks a lot Bart for the persistent testing - this was a nasty one to
>  track down. Find the standalone fix below.

Thanks to everyone who worked on this. By the way, I have asked Albert
Calahan, the procps maintainer, to fix the free/top/vmstat tools such
that these take recently added /proc/meminfo fields into account and
display correct values on recent 2.6 kernels. See also
http://bugzilla.kernel.org/show_bug.cgi?id=9991 and
http://marc.info/?l=linux-mm&m=120496901605830&w=2.

Bart.
