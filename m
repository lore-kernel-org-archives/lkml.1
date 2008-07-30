Return-Path: <linux-kernel-owner+w=401wt.eu-S1760515AbYG3WBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbYG3WBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759493AbYG3WBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:01:12 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:35509 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759443AbYG3WBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:01:09 -0400
Subject: Re: [PATCH] paravirt_ops: Use unsigned long instead of u32 for
	alloc_p*() pfn args
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4890E251.1090008@goop.org>
References: <1217453547-22231-1-git-send-email-ehabkost@redhat.com>
	 <4890E251.1090008@goop.org>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 14:59:53 -0700
Message-Id: <1217455193.30348.341.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-30 at 14:51 -0700, Jeremy Fitzhardinge wrote:
> Eduardo Habkost wrote:
> > This patch changes the pfn args from 'u32' to 'unsigned long'
> > on alloc_p*() functions on paravirt_ops, and the corresponding
> > implementations for Xen and VMI. The prototypes for CONFIG_PARAVIRT=n
> > are already using unsigned long, so paravirt.h now matches the prototypes
> > on asm-x86/pgalloc.h.
> >
> > It shouldn't result in any changes on generated code on 32-bit, with
> > or without CONFIG_PARAVIRT. On both cases, 'codiff -f' didn't show any
> > change after applying this patch.
> >
> > On 64-bit, there are (expected) binary changes only when CONFIG_PARAVIRT
> > is enabled, as the patch is really supposed to change the size of the
> > pfn args.
> >
> > Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
> >
> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Cc:ing Zach, since it touches vmi.

Thanks, looks good to me.  I always thought u32 is ugly type name anyway.

Acked-by: Zachary Amsden <zach@vmware.com>

