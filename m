Return-Path: <linux-kernel-owner+w=401wt.eu-S937151AbXHIAba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937151AbXHIAba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765544AbXHIAbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:31:21 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:42105 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765542AbXHIAbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:31:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TzbBon6V0P9qiAOT/0xcuatE1TAR0Sn50Ex4y+8KsiSU9wnnJqsMnDKHmsp/91d97xdxYWbw41l01tfIqk227I1ua2TIM3HvRnBx/EDG54MO4fVMuCRaUURcJ14e48Yi2r8nPrwcmgSHcYlGNcdaYHtefptqqaqr0tiXzEiyZJw=
Message-ID: <5d6222a80708081731y4e20e0a4oedc27e0766283b6a@mail.gmail.com>
Date: Wed, 8 Aug 2007 21:31:17 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: Introducing paravirt_ops for x86_64
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, lguest@ozlabs.org,
       virtualization@lists.linux-foundation.org, chrisw@sous-sol.org,
       anthony@codemonkey.ws, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <97D612E30E1F88419025B06CB4CF1BE10326E924@scsmsx412.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5d6222a80708080758t1b937d0ej14c5e60ac23a20c5@mail.gmail.com>
	 <97D612E30E1F88419025B06CB4CF1BE10326E924@scsmsx412.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/8/07, Nakajima, Jun <jun.nakajima@intel.com> wrote:
> > So, unless I'm very wrong,  it only makes sense to talk about not
> > supporting large pages in the guest level. But it is not a
> > paravirt_ops problem.
>
> Some MMU-related PV techiniques (including Xen, and direct paging mode
> for Xen/KVM) need to write-protect page tables, avoiding to use 2MB
> pages when mapping page tables. Looks like you did not, and that
> exaplains why the patches are missing the relevant (many) paravirt_ops
> in include/asm-x86_64/pgalloc.h, for example, compared with the i386
> tree.
I see.

I'll address this in the next version of the patch.


-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
