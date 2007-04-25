Return-Path: <linux-kernel-owner+w=401wt.eu-S1161624AbXDYGzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161624AbXDYGzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161625AbXDYGzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:55:44 -0400
Received: from terminus.zytor.com ([192.83.249.54]:56534 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161624AbXDYGzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:55:43 -0400
Message-ID: <462EFB66.1090907@zytor.com>
Date: Tue, 24 Apr 2007 23:55:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
CC: Tuncer Ayaz <tuncer.ayaz@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: NonExecutable Bit in 32Bit
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF052CFB78@ABGEX01E.abg.fsc.net> <Pine.LNX.4.64.0704240640470.25153@server.thyself> <4ac8254d0704240046s23b2d349m2e0f0caa7eb95a91@mail.gmail.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF0530256E@ABGEX01E.abg.fsc.net>
In-Reply-To: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF0530256E@ABGEX01E.abg.fsc.net>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cestonaro, Thilo (external) wrote:
> Hey,
> 
>> CONFIG_HIGHMEM64G=y
>> CONFIG_HIGHMEM=y
>> CONFIG_X86_PAE=y
> 
> Ok in highmem it's active, whats about lowmem?

It's not highmem vs lowmem, it is that HIGHMEM64G is required for
X86_PAE, which is required for NX support.

> x86-64 is NX active for lowmem too AFAIK.

Good thing, since x86-64 doesn't have highmem (nor does it need it,
since it has enough virtual address space to map all physical address
space and still have left over, like it *should* be.)

	-hpa
