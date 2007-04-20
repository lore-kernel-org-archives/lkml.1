Return-Path: <linux-kernel-owner+w=401wt.eu-S2993108AbXDTR6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993108AbXDTR6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 13:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993084AbXDTR6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 13:58:25 -0400
Received: from agrajag.inprovide.com ([82.153.166.94]:58488 "EHLO
	mail.mansr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993108AbXDTR6Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 13:58:24 -0400
X-Greylist: delayed 2021 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Apr 2007 13:58:24 EDT
To: Andi Kleen <ak@suse.de>
Cc: discuss@x86-64.org, =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [discuss] Dropping CONFIG_REORDER on x86-64 for 2.6.22
References: <200704191354.52985.ak@suse.de> <46277C36.6030301@linux.intel.com>
	<yw1x4pnba1fl.fsf@thrashbarg.mansr.com>
	<200704201137.45799.ak@suse.de>
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Date: Fri, 20 Apr 2007 18:24:42 +0100
In-Reply-To: <200704201137.45799.ak@suse.de> (Andi Kleen's message of "Fri, 20 Apr 2007 11:37:45 +0200")
Message-ID: <yw1xr6qf7ycl.fsf@thrashbarg.mansr.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (Double Solitaire, linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> On Friday 20 April 2007 10:35:10 Måns Rullgård wrote:
>> Arjan van de Ven <arjan@linux.intel.com> writes:
>> 
>> > Andi Kleen wrote:
>> >> Rationale:
>> >> - It cannot be enabled in normal builds because all current lds
>> >> become very slow when they have to handle thousands of sections.
>> >>
>> >
>> > afaik this is only ever reported on SuSE; I've not heard it on any
>> > other distro...
>> 
>> Even with that option set, the full kernel build with my configuration
>> finishes in one minute flat on my Gentoo box.  Could it be that the
>> linker uses enormous amounts of memory?  I have 4GB so I wouldn't
>> immediately notice.
>
> What binutils version do you use? Maybe that particular problem is
> finally fixed.  Of course would still leave the other issues I
> listed.

I'm using the Gentoo default, which is 2.16.1 plus some patches.  A
quick scan of the patches suggests that perhaps this one has something
to do with it:
http://sources.redhat.com/ml/binutils/2005-03/msg00847.html

-- 
Måns Rullgård
mans@mansr.com
