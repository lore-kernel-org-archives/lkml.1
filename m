Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZBDA1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZBDA1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 19:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZBDA06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 19:26:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43825 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbZBDA06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 19:26:58 -0500
Message-ID: <4988E001.3000503@kernel.org>
Date: Tue, 03 Feb 2009 16:23:29 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] x86/paravirt: return full 64-bit result
References: <4988DAA6.7000102@goop.org>
In-Reply-To: <4988DAA6.7000102@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> A hunk went missing in the original patch, and callee-save callsites were
> not marked as returning the upper 32-bit of result, causing Badness.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Applied to tip:x86/paravirt.  Thanks!

	-hpa
