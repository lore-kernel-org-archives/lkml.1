Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXFATrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXFATrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762040AbXFATqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:46:55 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:23202 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762026AbXFATqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mmRM6NfJsHapA6xxczfXIhRxiUTjD7H4arRDh6J8MrFnI8ReR7sxBlSaKtImMm6sl80JM7YqZNgkuSs6BL+tcqhM1aty5k4OEMazH3PFtyGOEMpisn7YUoCUqLJfoT7ois7AFk8m5stz/g+GBf6hP4xGMedu+s3nmQpIV9I9r0I=
Message-ID: <86802c440706011246n795ecabfke0dfd1a695ba5e5f@mail.gmail.com>
Date: Fri, 1 Jun 2007 12:46:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 2/3]i386: early init pgt for fix virtual addr in head.S
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Greg KH" <gregkh@suse.de>, "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1ps4fzdq0.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705202219o21d11023od1018d253364bf5c@mail.gmail.com>
	 <m1ps4fzdq0.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
>
> > early init pgt for fix virtual addr in head.S, so can use set_fixmap
> > before setup_arch.
> > otherwise set_fixmap_nocache will not work for i386
> >
> > Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>
> Hmm.  I'm wondering how my signed off by got on this one.
> Maybe I did this at some point.
>
> In any case this patch looks wrong (unless I'm completely mistaken)
> because it doesn't appear to handle PAE mode.
>
> Which is why I initialized the early page table in C, in my
> last round of patches on this subject.
>
> If we don't know the page table format doing this kind of
> thing is very difficult.

it is from post for your usb debug port patch. so you have updated one for i386?
and x86_64 is right?

YH
