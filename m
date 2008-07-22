Return-Path: <linux-kernel-owner+w=401wt.eu-S1755958AbYGVDtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958AbYGVDtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 23:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYGVDta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 23:49:30 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:39065 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbYGVDta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 23:49:30 -0400
Date: Tue, 22 Jul 2008 04:49:10 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: BUILD_IRQ say .text to avoid .data.percpu
In-Reply-To: <48851AF0.5070309@sgi.com>
Message-ID: <Pine.LNX.4.64.0807220444460.3190@blonde.site>
References: <Pine.LNX.4.64.0807211828470.26173@blonde.site> <48851AF0.5070309@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jul 2008, Mike Travis wrote:
> Hugh Dickins wrote:
> > When I edit the x86_64 Makefile to -fno-unit-at-a-time, bootup panics
> > on 0xCCs in IRQ0x3e_interrupt(): IRQ0x20_interrupt etc. have got linked
> > into .data.percpu.  Perhaps there are other ways of triggering that:
> > specify ".text" in the BUILD_IRQ() macro for safety.
>
> Thanks Hugh.  Btw, which GCC are you using?

openSUSE 10.3's gcc (GCC) 4.2.1 (SUSE Linux)
along with their binutils-2.17.50.20070726-14

Hugh
