Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZCPO30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZCPO30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZCPO3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:29:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:43447 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbZCPO3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:29:16 -0400
Date: Mon, 16 Mar 2009 07:29:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Jan Beulich" <jbeulich@novell.com>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
Message-ID: <20090316072904.733e7e43@infradead.org>
In-Reply-To: <49BE6D50.76E4.0078.0@novell.com>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
	<1236931920-6861-11-git-send-email-jeremy@goop.org>
	<49BA3A84.76E4.0078.0@novell.com>
	<49BA7810.6090807@goop.org>
	<49BD4CE1.6040100@zytor.com>
	<49BD6D0E.1010107@goop.org>
	<20090315154718.00353625@infradead.org>
	<49BD97C6.2070401@goop.org>
	<20090315170945.08344b86@infradead.org>
	<49BE6D50.76E4.0078.0@novell.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 14:16:32 +0000
"Jan Beulich" <jbeulich@novell.com> wrote:

> >>> Arjan van de Ven <arjan@infradead.org> 16.03.09 01:09 >>>
> >Well.. pretty much all new instructions need Xen modifications due to
> >the need to be emulate to deal with traps/vmexits/etc right? 
> >So I don't quite see many cpuid bits that would NOT involve some Xen
> >modification or another ;)
> 
> No, new (user-mode accessible) instructions represent precisely the
> kind of extension that do not require hypervisor (or OS) awareness
> (see SSE2 etc, AES, FMA). 

so Xen doesn't need to handle a case where the kernel does AES on
uncached IO memory ?


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
