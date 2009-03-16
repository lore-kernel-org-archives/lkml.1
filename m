Return-Path: <linux-kernel-owner+w=401wt.eu-S1757147AbZCPBGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757147AbZCPBGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 21:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZCPBGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 21:06:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57828 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbZCPBGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 21:06:43 -0400
Message-ID: <49BDA415.9060502@zytor.com>
Date: Sun, 15 Mar 2009 17:57:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Jan Beulich <jbeulich@novell.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>	<1236931920-6861-11-git-send-email-jeremy@goop.org>	<49BA3A84.76E4.0078.0@novell.com>	<49BA7810.6090807@goop.org>	<49BD4CE1.6040100@zytor.com>	<49BD6D0E.1010107@goop.org>	<20090315154718.00353625@infradead.org>	<49BD97C6.2070401@goop.org> <20090315170945.08344b86@infradead.org>
In-Reply-To: <20090315170945.08344b86@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> 
> Well.. pretty much all new instructions need Xen modifications due to
> the need to be emulate to deal with traps/vmexits/etc right? 
> So I don't quite see many cpuid bits that would NOT involve some Xen
> modification or another ;)
> 

There are going to be a very small number which need only userspace
support.  However, there will be absolutely no way for Xen to know this
a priori.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

