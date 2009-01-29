Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbZA2HbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbZA2HbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 02:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZA2Ha6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 02:30:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44308 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZA2Ha6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 02:30:58 -0500
Message-ID: <49815764.6040809@kernel.org>
Date: Wed, 28 Jan 2009 23:14:44 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ravikiran Thirumalai <kiran@scalemp.com>
Subject: Re: [PATCH 0 of 7] x86/paravirt: optimise pvop calls and register
 use
References: <patchbomb.1233182100@abulafia.goop.org>
In-Reply-To: <patchbomb.1233182100@abulafia.goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeremy,

First of all, thanks for tackling this issue.

I tried applying this patchset to tip:x86/paravirt, but I got the
following build error when applied on top of tip:x86/core:

/home/hpa/kernel/linux-2.6-tip.paravirt/arch/x86/include/asm/paravirt.h:
In function ‘pud_val’:
/home/hpa/kernel/linux-2.6-tip.paravirt/arch/x86/include/asm/paravirt.h:1324:
error: invalid operands to binary == (have ‘struct paravirt_callee_save’
and ‘void *’)


The failing configuration was x86-64 "make allyesconfig".

	-hpa
