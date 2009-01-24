Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZAXVgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZAXVgO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 16:36:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbZAXVf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 16:35:58 -0500
Received: from mail-out4.apple.com ([17.254.13.23]:63127 "EHLO
	mail-out4.apple.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbZAXVf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 16:35:58 -0500
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Jan 2009 16:35:58 EST
X-AuditID: 11807130-a508abb000000fcd-6c-497b876113c1
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Message-Id: <F9975969-B497-4BBB-BAB9-A3112A12D1D0@apple.com>
From: Mike Stump <mrs@apple.com>
To: LLVM Developers Mailing List <llvmdev@cs.uiuc.edu>
In-Reply-To: <497B648E.7020805@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [LLVMdev] inline asm semantics: output constraint width smaller than input
Date: Sat, 24 Jan 2009 13:25:52 -0800
References: <497A0500.3080706@gmail.com> <20090123181721.GA32545@elte.hu> <497A0C0A.7080207@gmail.com> <497B408C.20802@gmail.com> <20090124172758.GA31699@elte.hu> <497B648E.7020805@gmail.com>
X-Mailer: Apple Mail (2.930.3)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 24, 2009, at 10:57 AM, Török Edwin wrote:
> With an unpatched LLVM I would also need weak attributes to be on the
> function type, instead of the return type,
> but I think thats an LLVM bug, and a one-line patch corrects it.

This is indeed a bug in llvm.  We'll find a way to get it fixed.