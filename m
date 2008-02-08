Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbYBHVSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbYBHVSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbYBHVSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:18:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42694 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508AbYBHVSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:18:37 -0500
Message-ID: <47ACC6F2.8050601@zytor.com>
Date: Fri, 08 Feb 2008 13:17:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] x86: change most X86_32 pt_regs members to unsigned
 long
References: <1202501396.12966.20.camel@brick> <20080208211344.GB15571@martell.zuzino.mipt.ru>
In-Reply-To: <20080208211344.GB15571@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> Why?! You don't have even minimal chances to unify pt_regs for i386 and
> x86_64.

The structure itself, no.  Some of the users may very well be candidates 
for unification, however.

	-hpa
