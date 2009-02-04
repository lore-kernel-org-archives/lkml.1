Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZBDB0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZBDB0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZBDB0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:26:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZBDB0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:26:43 -0500
Message-ID: <4988EE04.7090006@kernel.org>
Date: Tue, 03 Feb 2009 17:23:16 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] xen: disable interrupts before saving in percpu
References: <4988DAEA.6040608@goop.org>
In-Reply-To: <4988DAEA.6040608@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> xen_mc_batch has a small preempt race where it takes the address of a
> percpu variable immediately before disabling interrupts, thereby
> leaving a small window in which we may migrate to another cpu and save
> the flags in the wrong percpu variable.  Disable interrupts before
> saving the old flags in a percpu.

Applied to tip:core/xen, thanks!

	-hpa
