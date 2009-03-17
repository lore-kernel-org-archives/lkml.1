Return-Path: <linux-kernel-owner+w=401wt.eu-S1763260AbZCQKsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763260AbZCQKsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbZCQKrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:47:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57145 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774AbZCQKry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:47:54 -0400
Date: Tue, 17 Mar 2009 11:48:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
Message-ID: <20090317104817.GO11935@one.firstfloor.org>
References: <1236931920-6861-11-git-send-email-jeremy@goop.org> <49BA3A84.76E4.0078.0@novell.com> <49BA7810.6090807@goop.org> <49BD4CE1.6040100@zytor.com> <49BD6D0E.1010107@goop.org> <20090315154718.00353625@infradead.org> <49BD97C6.2070401@goop.org> <20090315170945.08344b86@infradead.org> <87fxhd2f53.fsf@basil.nowhere.org> <49BF6505.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BF6505.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No, properly coded xsave support will (hopefully) make user-visible context
> extensions transparent to hypervisor and OS. But I was giving a general
> example here, and the change from xmm to ymm registers is one that does
> need hypervisor (and OS) changes.

Again except for XSAVE support it doesn't, does it?

-Andi
