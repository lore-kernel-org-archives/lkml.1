Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbZCPALS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbZCPALS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 20:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZCPALG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 20:11:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:46199 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbZCPALF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 20:11:05 -0400
Date: Sun, 15 Mar 2009 17:09:45 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
Message-ID: <20090315170945.08344b86@infradead.org>
In-Reply-To: <49BD97C6.2070401@goop.org>
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>
	<1236931920-6861-11-git-send-email-jeremy@goop.org>
	<49BA3A84.76E4.0078.0@novell.com>
	<49BA7810.6090807@goop.org>
	<49BD4CE1.6040100@zytor.com>
	<49BD6D0E.1010107@goop.org>
	<20090315154718.00353625@infradead.org>
	<49BD97C6.2070401@goop.org>
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

On Sun, 15 Mar 2009 17:05:26 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Arjan van de Ven wrote:
> > This is indicative of something that might be a huge bug in Xen:
> > Xen should never ever pass through CPUID bits it does not know.
> > If Xen does not honor that, there is a fundamental and eternally
> > recurring problem.... every time something new gets introduced Xen
> > likely breaks.
> 
> Yes, I'd agree; Xen should whitelist cpu capabilities rather than 
> blacklist them.  Jan expressed the opposite opinion (on the grounds
> that it precludes using features which don't require special OS or
> hypervisor support without Xen modifications).

Well.. pretty much all new instructions need Xen modifications due to
the need to be emulate to deal with traps/vmexits/etc right? 
So I don't quite see many cpuid bits that would NOT involve some Xen
modification or another ;)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
