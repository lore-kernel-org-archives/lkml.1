Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYAUSq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYAUSq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 13:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYAUSqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 13:46:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56081 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751403AbYAUSqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 13:46:22 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86_64: check if Tom2 is enabled
Date: Mon, 21 Jan 2008 19:46:15 +0100
User-Agent: KMail/1.9.6
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Yinghai Lu <Yinghai.Lu@sun.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jesse.barnes@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200801192045.17291.yinghai.lu@sun.com> <20080121180913.GD6722@cvg> <4794E130.2090402@zytor.com>
In-Reply-To: <4794E130.2090402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801211946.16049.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Actually, I think it depends on the specific MSR - some use the halves 
> for different data, whereas others treat it as a large 64-bit object.

Even if there are different fields in there it is still much cleaner
and simpler if there is only a single number to manipulate.

> Ironically enough, the way the MSR interfaces were carried into the 
> 64-bit world makes the situation worse on 64 bits; edx:eax is the common 
> way to represent a 64-bit value on 32 bits.

It's merely an implementation detail of the instruction. But even on 32bit
there is about zero reason to expose that to C code. rdmsr/wrmsr et.al. should
have been defined as 64bit only interface in Linux from day zero.

-Andi
