Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbYFPLnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbYFPLnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 07:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYFPLnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 07:43:07 -0400
Received: from gw.goop.org ([64.81.55.164]:42533 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbYFPLnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 07:43:05 -0400
Message-ID: <485651A0.9080705@goop.org>
Date: Mon, 16 Jun 2008 04:42:24 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Stable Kernel <stable@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH BUGFIX] xen: don't drop NX bit
References: <48565028.6090907@goop.org>
In-Reply-To: <48565028.6090907@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> When converting the pfn/mfn in a pagetable entry, make sure we mask
> out the protection flags properly.  Formerly, this code was losing the
> NX bit, and not dealing with extra Xen-defined software flags in ptes.
>
> Because NX is now enforced properly, we must put the hypercall page
> into the .text segment so that it is executable.

Oops, ignore this.  This depends on another unposted patch.  I'll repost 
shortly.

    J
