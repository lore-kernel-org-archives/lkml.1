Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbYDIJEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbYDIJEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 05:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbYDIJE0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 05:04:26 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:57249 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbYDIJE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 05:04:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uRH9Rcj14i8PiaPoQGGzcGE3xuBabM6IfP74Z0zsP3hANr6degD6OKVIOrzM3c3JqDEJ3RS0n0Xjbvp0DZsqeBWrcpBqkJXZUJErfTsLYFXyN6ERwdZd6C+/F/DDuIdmhp3y20iA24cMKkXojVOcoTQYX22fnYIA3/PFwDctl2U=
Message-ID: <ac8af0be0804090204t79beaca2qe077a28fc4a515ad@mail.gmail.com>
Date: Wed, 9 Apr 2008 17:04:24 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Does Linux have plan to support memory hole remapping?
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       mingo@elte.hu, ak@suse.de
In-Reply-To: <87iqyro3rc.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com>
	 <87iqyro3rc.fsf@basil.nowhere.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/08, Andi Kleen <andi@firstfloor.org> wrote:
> "Zhao Forrest" <forrest.zhao@gmail.com> writes:
> >
> > As we can see from above information that the physical memory in system
> > is 32768MB(32GB). However OS is only using about
> > (32768-512)MB(MemTotal:     33010240 kB). Does this mean that this
> > linux kernel can't use the physical memory remapped
> > from (4G-512M, 4G) to (32G, 32G+512M)?
>
> The linux kernel can only use the memory passed to it by the BIOS.
> Sometimes they need special BIOS setup options to enable remapping. If
> there are no such options and you can't upgrade it you're out of luck

Yes, I have enabled mem hole remapping in BIOS SETUP.
After looking into dmesg, I found that all 32GB physical memory has
been allocated to 8 nodes, but why MemTotal shows a less amount of
memory than 32GB? Interesting......
Does MemTotal means the amount of physical memory allocated to all
nodes? Or it has different meanings?

Thanks,
Forrest
