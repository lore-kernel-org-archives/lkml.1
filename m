Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZEMABZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZEMABZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbZEMABP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:01:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44724 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbZEMABO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:01:14 -0400
Message-ID: <4A0A0D7C.8050206@zytor.com>
Date: Tue, 12 May 2009 16:59:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH FIXED] x86: use flush_tlb_others to implement flush_tlb_all
References: <4A09E5FE.2080507@goop.org>
In-Reply-To: <4A09E5FE.2080507@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> +        /* +         * flush_mm == NULL means flush everything, including

Hi Jeremy,

This patch arrived corrupted; it has several lines like this.

	-hpa
