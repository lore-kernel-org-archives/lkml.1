Return-Path: <linux-kernel-owner+w=401wt.eu-S1752466AbYAHWN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752466AbYAHWN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYAHWNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:13:10 -0500
Received: from nz-out-0506.google.com ([64.233.162.231]:60056 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbYAHWNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:13:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=biY5S7KN7bK69ThjGnbUrxCF3xlEGrB3KQBM0n+1vfaa0tVZqqsXXIoyP7YDX3BV2ZtjwdOKqyDE18nvow4HVS5UuC9gRHnMLyRKQEGCIhHxc6YKxb9DO9dz6DR90Bj35huESf45T7uuacxOrybt4GKXtZDEtxj6ezF/R0uZPFc=
Message-ID: <21d7e9970801081413n307ab07aq462a9fff014143ae@mail.gmail.com>
Date: Wed, 9 Jan 2008 08:13:05 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: Replacement for page fault notifiers?
Cc: "Pekka Paalanen" <pq@iki.fi>, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, proski@gnu.org
In-Reply-To: <20080108203235.GA772@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080108210638.5c9e093a@daedalus.pq.iki.fi>
	 <20080108203235.GA772@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 9, 2008 6:32 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jan 08, 2008 at 09:06:38PM +0200, Pekka Paalanen wrote:
> > - Is there anything coming to replace register_page_fault_notifier()?
>
> no.
>
> > - Has someone found another way to accomplish the same without patching
> > the kernel?
>
> no.
>
> > - Should I start writing a patch to bring back the notifiers, based on
> > the commit that removed them?
>
> no.
>
> > People started to complain to me that mmio-trace does not compile for
> > 2.6.24. At least the Nouveau project is a regular user of mmio-trace
> > for reverse-engineering, and the tool should be easy to use. Therefore
> > I would prefer not to force casual contributors to patch their kernels
> > as it might be too much for some. I am hoping that 2.6.25, if not
> > 2.6.24, would contain a mechanism to accomplish what I need.
>
> Please make mmio tracing generic enough so it works for every device and
> submit it for inclusion as a config option.
>

Christoph,

it is generic code, it works by patching the module you load and is in
no way nvidia specific, I think we should revert your chance
as the notifiers have a valid user and one it has been planned to upstream..

Dave.
