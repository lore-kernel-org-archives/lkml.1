Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZCJBLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZCJBLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZCJBLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:11:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50651 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZCJBLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:11:09 -0400
Message-ID: <49B5BD63.1090909@zytor.com>
Date: Mon, 09 Mar 2009 18:07:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH] paravirt/xen: add pvop for page_is_ram
References: <1235786365-17744-1-git-send-email-jeremy@goop.org> <1235786365-17744-10-git-send-email-jeremy@goop.org>
In-Reply-To: <1235786365-17744-10-git-send-email-jeremy@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> A guest domain may have external pages mapped into its address space,
> in order to share memory with other domains.  These shared pages are
> more akin to io mappings than real RAM, and should not pass the
> page_is_ram test.  Add a paravirt op for this so that a hypervisor
> backend can validate whether a page should be considered ram or not.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 

Why are these pages mapped as RAM in the memory map?  That is the right
way to handle that, not by adding yet another bloody hook...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

