Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbZFJEYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbZFJEYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 00:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbZFJEYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 00:24:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42946 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbZFJEYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 00:24:36 -0400
Message-ID: <4A2F353A.9040007@kernel.org>
Date: Tue, 09 Jun 2009 21:23:22 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Harald Welte <HaraldWelte@viatech.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH] X86: cpu_debug support for VIA / Centaur CPU's
References: <20090609082931.GD25316@prithivi.gnumonks.org> <1244537598.2558.9.camel@ht.satnam> <20090609145305.GD3986@prithivi.gnumonks.org> <20090609151557.GA9362@elte.hu>
In-Reply-To: <20090609151557.GA9362@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> MSRs should really be enumerated along CPU features. They will be 
> accessed if a CPU offers that CPU feature.
> 

Nice in theory, but so many MSRs have to be enumerated with obscure test
combinations, that it really isn't practical in the general case.  That
is why we have the safe MSR variants.

> 
> Yeah, the safe read should never fault - there should be all zeroes 
> or an error return.
> 

Error return, MSRs #GP if not present.  All zero means a present MSR
(which is zero.)

	-hpa

