Return-Path: <linux-kernel-owner+w=401wt.eu-S936352AbXHJPGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936352AbXHJPGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759899AbXHJPFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:05:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:54648 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759245AbXHJPFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LLNlmev1N5Ddono4HY7ydWV/IUc1bSyRDpoJa9UTxh/OnUoaYyRtG+F/bOQUSeahe7ziY9qsguaUTfpDoJ2cEp3ayy/04/SziTKgrgcoNZnPqiwCKqdBm+UxvZMnXKvpHU87fmUM88eBLMYVFvu8521FmlwWAfIO9dnx6Z1w6oI=
Message-ID: <6bffcb0e0708100805i417834e5t87a1ebf122c1e264@mail.gmail.com>
Date: Fri, 10 Aug 2007 17:05:50 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc2-mm2
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Nick Piggin" <nickpiggin@yahoo.com.au>
In-Reply-To: <46BC7BDA.3000305@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809224254.11f42716.akpm@linux-foundation.org>
	 <46BC7BDA.3000305@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi,
>
> Andrew Morton pisze:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc2/2.6.23-rc2-mm2/
> >
> [..]
> > +sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
> > +sysctl-factor-out-sysctl_data.patch
> > +sysctl-error-on-bad-sysctl-tables.patch
> > +sysctl-update-sysctl_check_table.patch
> > +sysct-mqueue-remove-the-binary-sysctl-numbers.patch
> > +sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
> > +sysctl-fix-neighbour-table-sysctls.patch
> > +sysctl-ipv6-route-flushing-kill-binary-path.patch
> > +sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
> > +sysctl-x86_64-remove-unnecessary-binary-paths.patch
> > +sysctl-remove-broken-cdrom-binary-sysctls.patch
> > +sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
> > +sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
> >
> >  sysctl cleanups
>
> There is something wrong with sysctl

Ah, it is intended.
sysctl-error-on-bad-sysctl-tables.patch

>
> [   25.120741] sysctl_check_dir: failed: /kernel  ref: /kernel .1
> [   25.127102] sysctl table check failed: /kernel  Writable sysctl directory
> [   25.134157] sysctl table check failed: /kernel  Inconsistent directory names
> [   25.141477] sysctl table check failed: /kernel/sched_domain  Writable sysctl directory
> [   25.149755] sysctl table check failed: /kernel/sched_domain/cpu0  Writable sysctl directory
> [   25.158529] sysctl table check failed: /kernel/sched_domain/cpu0/domain0  Writable sysctl directory
> [   25.168102] sysctl table check failed: /kernel/sched_domain/cpu1  Writable sysctl directory
> [   25.176862] sysctl table check failed: /kernel/sched_domain/cpu1/domain0  Writable sysctl directory
>
> Eric?
>

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
