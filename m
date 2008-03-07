Return-Path: <linux-kernel-owner+w=401wt.eu-S932400AbYCGJbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400AbYCGJbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932513AbYCGJ2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:28:16 -0500
Received: from main.gmane.org ([80.91.229.2]:38496 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763579AbYCGJ2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:28:09 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Subject: Re: [PATCH 2.6.24] chroot= as a new kernel parameter
Date: Fri, 07 Mar 2008 09:27:57 +0000
Message-ID: <yw1xod9qhoiq.fsf@thrashbarg.mansr.com>
References: <200803060001.38432.paplociennik@gmail.com> <47CF79E4.3030107@zytor.com> <20080306102712.GE13391@elte.hu> <47D00B16.6040004@zytor.com> <20080306212028.GB1747@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: thrashbarg.mansr.com
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (Educational Television, linux)
Cancel-Lock: sha1:Cy6lYhvFSPq/RBNnwrSBorka/+k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> On Thu 2008-03-06 07:17:42, H. Peter Anvin wrote:
>> Ingo Molnar wrote:
>>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>>
>>>> Pawel Plociennik wrote:
>>>>> Hi Andrew and other *real* hackers,
>>>>>
>>>>> I have sent a *last* version of a patch which it has added a new kernel parameter chroot=
>>>>> It were discusioned a *long time* on a lkml so I hope that it will has been applied.
>>>> It has been discussed and *rejected* a large number of times.
>>>>
>>>> This is completely useless bloat.
>>>
>>> why is it useless? Would it be more acceptable were it made dependent on a 
>>> .config option?
>>>
>>
>> It's useless because it's exactly and trivially replaceable with:
>>
>> 	init=/path/to/any/sbin/chroot /newroot /sbin/init
>
> No, that will not work, if you don't have libraries at /. This should
> be exact replacement:
>
> init=/working_distro/lib/ld-linux.so.2 --library-path /working_distro/lib /working_distro/usr/sbin/chroot /working_distro/ /sbin/init
>
> ...assuming your chroot uses ld-linux.so.2. I believe above is ugly
> enough to warrant merge of chroot= option.

I fail to see how a chroot= option would solve the problem of locating
libraries.  If standard library paths won't work, linking chroot
statically seems the cleaner solution.

-- 
Måns Rullgård
mans@mansr.com

