Return-Path: <linux-kernel-owner+w=401wt.eu-S1761060AbYCDBfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060AbYCDBfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:35:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbYCDBe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:34:59 -0500
Received: from ozlabs.org ([203.10.76.45]:37531 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbYCDBe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:34:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] lguest: include function prototypes
Date: Tue, 4 Mar 2008 12:34:13 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
References: <1202937275.18204.1.camel@brick>
In-Reply-To: <1202937275.18204.1.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803041234.13480.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2008 08:14:35 Harvey Harrison wrote:
> Fix for sparse warning
> arch/x86/lguest/boot.c:939:13: warning: symbol 'lguest_init' was not
> declared. Should it be static?
>
> Added a declaration to asm-x86/lguest.h and moved the extern arrays there
> as well.  As an alternative to including asm/lguest.h directly, an
> include could be put in linux/lguest.h

Hi Harvey,

   Thanks for the patch.  Currently asm/lguest.h is used for the guest/host 
interface definitions, while these are purely in-guest symbols.  The standard 
for these 'used from asm/declared in asm' seems to be to put the declarations 
in the C file directly.

   However, since this has already been applied to Linus' tree, it's fine.

Thanks!
Rusty.
