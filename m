Return-Path: <linux-kernel-owner+w=401wt.eu-S1757706AbZCPAFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706AbZCPAFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 20:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZCPAFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 20:05:33 -0400
Received: from gw.goop.org ([64.81.55.164]:39495 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZCPAFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 20:05:32 -0400
Message-ID: <49BD97C6.2070401@goop.org>
Date: Sun, 15 Mar 2009 17:05:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@novell.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
References: <1236931920-6861-1-git-send-email-jeremy@goop.org>	<1236931920-6861-11-git-send-email-jeremy@goop.org>	<49BA3A84.76E4.0078.0@novell.com>	<49BA7810.6090807@goop.org>	<49BD4CE1.6040100@zytor.com>	<49BD6D0E.1010107@goop.org> <20090315154718.00353625@infradead.org>
In-Reply-To: <20090315154718.00353625@infradead.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> This is indicative of something that might be a huge bug in Xen:
> Xen should never ever pass through CPUID bits it does not know.
> If Xen does not honor that, there is a fundamental and eternally
> recurring problem.... every time something new gets introduced Xen
> likely breaks.

Yes, I'd agree; Xen should whitelist cpu capabilities rather than 
blacklist them.  Jan expressed the opposite opinion (on the grounds that 
it precludes using features which don't require special OS or hypervisor 
support without Xen modifications).  But if its just a matter of 
sticking a bit into a mask, its easy and quick to roll a new version of 
Xen (esp since it can generally be done before CPUs with the new feature 
get into people's hands).

    J

