Return-Path: <linux-kernel-owner+w=401wt.eu-S1755044AbXLJI6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044AbXLJI6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 03:58:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbXLJI5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 03:57:53 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60978 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036AbXLJI5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 03:57:52 -0500
Date: Mon, 10 Dec 2007 14:27:41 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] Instrumentation menu removal, against 2.6.24-rc4-mm1 (mmotm)
Message-ID: <20071210085741.GA8437@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20071208153255.078261362@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071208153255.078261362@polymtl.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2007 at 10:32:55AM -0500, Mathieu Desnoyers wrote:
> Hi Andrew,
> 
> This time I am taking no chance :
> 
> The instrumentation menu removal patchset here applies against 2.6.24-rc4-mm1
> _and_ against mmotm (dated : stamp-2007-12-05-15-24) without problem.
> 
> We should hopefully be able to stop racing against other architecture specific
> fixes done underneath. Please be aware that the following fix :
> 
> - fix-oprofile-configuration-breakage.patch
> 
> from MIPS did not show up in your mmotm tree. I guess you just sent it upstream
> without keeping it in your own tree. I have applied the content of this fix in
> my patchset (meaning : select HAVE_OPROFILE if !MIPS_MT_SMTC in
> add-have-oprofile.patch), but I think you might have a reject if you still have
> this fix-oprofile-configuration-breakage.patch in your local tree but not in
> mmotm.

Mathieu,

With this patchset, a `make defconfig' results in:

CONFIG_OPROFILE=y
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_KPROBES=y

You probably also need to change the defconfigs...

Ananth
