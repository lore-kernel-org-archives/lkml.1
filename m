Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZIPNjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZIPNjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZIPNji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:39:38 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:25745 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZIPNjh (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 16 Sep 2009 09:39:37 -0400
Date: Wed, 16 Sep 2009 09:24:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Miroslav Rezanina <mrezanin@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: [PATCH][v2.6.29][XEN] Return unused memory to
	hypervisor
Message-ID: <20090916132456.GA14725@phenom.dumpdata.com>
References: <1582654680.152201253087647836.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <1250041003.152221253087777235.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250041003.152221253087777235.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AB0EA8E.00A2:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. snip ..
>  static void xen_vcpu_setup(int cpu)
>  {
> @@ -1057,6 +1111,8 @@ static __init void xen_post_allocator_init(void)
>  	SetPagePinned(virt_to_page(level3_user_vsyscall));
>  #endif
>  	xen_mark_init_mm_pinned();
> +
> +/*	xen_return_unused_memory(); */

Should this be commented out? Or do you plan to provide another
patch to enable this after extensive testing?
