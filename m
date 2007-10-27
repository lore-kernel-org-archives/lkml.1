Return-Path: <linux-kernel-owner+w=401wt.eu-S1761781AbXJ0AM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761781AbXJ0AM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 20:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXJ0AMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 20:12:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55760 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640AbXJ0AMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 20:12:48 -0400
Message-ID: <47228278.8070505@garzik.org>
Date: Fri, 26 Oct 2007 20:12:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Salyzyn, Mark" <mark_salyzyn@adaptec.com>,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 7/9] irq-remove: scsi driver trivial
References: <20071019075443.GA6407@havoc.gtf.org>	<20071019075808.GH6407@havoc.gtf.org>	<AE4F746F2AECFC4DA4AADD66A1DFEF01F3D54D@otce2k301.adaptec.com>	<20071026143525.b9218ed7.akpm@linux-foundation.org>	<4722608E.3000405@garzik.org> <20071026165035.33383e36@laptopd505.fenrus.org>
In-Reply-To: <20071026165035.33383e36@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Fri, 26 Oct 2007 17:47:58 -0400
> Jeff Garzik <jeff@garzik.org> wrote:
> 
>> Andrew Morton wrote:
>>> That was a goofup.  I proposed that we should add a #define
>>> TWO_ARG_IRQ_HANDLERS (or whatever) and I think I actually wrote the
>>> patch, but it got lost.
>>>
>>> I agree it would be a kind thing to do in this case.
> 
>>
>> Yep, I was thinking that including
>>
>> 	#define IRQ_HANDLER_V3
>>
>> would be a good idea.
>>
> 
> it sets a certain precedent though.... we don't do this for the 500
> other API changes we do each release (see stable-api-nonsense)... so
> this one is mostly arbitrary picked out

We do for include/linux/netdevice.h, see HAVE_xxx -- and we should do it 
because the last irq handler change was a pain for backports, and this 
makes life easier for the backporters.  irq handling is probably far 
more global than any other kernel API except kmalloc()

	Jeff



