Return-Path: <linux-kernel-owner+w=401wt.eu-S1761532AbYCGIsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761532AbYCGIsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbYCGIsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:48:06 -0500
Received: from smtp-out.google.com ([216.239.45.13]:61229 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbYCGIsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:48:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=RsIIR+UUf66kUJUyXP8pDCk9r+7epM2lhCJW8FJCkwk1CZt4P7bBkapM3SdVrmv8u
	78EnP+TL1Aq74eFWJq21g==
Message-ID: <6599ad830803070047l1b108fc5je19791362291018@mail.gmail.com>
Date: Fri, 7 Mar 2008 00:47:54 -0800
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
Cc: a.p.zijlstra@chello.nl, maxk@qualcomm.com, mingo@elte.hu,
       tglx@linutronix.de, oleg@tv-sign.ru, rostedt@goodmis.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
In-Reply-To: <20080307003924.6dcb16a3.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080227222103.673194000@chello.nl>
	 <20080304013534.4e51ae48.pj@sgi.com> <1204628762.6241.46.camel@lappy>
	 <47CDA885.3000103@qualcomm.com> <20080304191159.a02be58b.pj@sgi.com>
	 <1204706272.6241.79.camel@lappy> <20080306074729.6233e537.pj@sgi.com>
	 <1204816885.6241.265.camel@lappy> <20080306214003.aba81840.pj@sgi.com>
	 <20080307003924.6dcb16a3.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2008 at 10:39 PM, Paul Jackson <pj@sgi.com> wrote:
>  I guess this will require adding a line:
>         .create = cgroup_create
>  line to the:
>         static struct file_operations cgroup_file_operations = {
>  initialization in kernel/cgroup.c, and a cgroup_create() routine
>  in kernel/cgroup.c, that calls an optional per-cgroup-subsystem
>  create routine, that, in the case of cpusets, is willing to create
>  one of these irqs.N.name files, in the top cpuset, if all looks
>  right.
>

An alternative would be to just have some kind of "irqsets" file in
the top-level cpuset directory and let the user write irq group
definitions into that file.

Paul
