Return-Path: <linux-kernel-owner+w=401wt.eu-S1754528AbYDWWml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbYDWWml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYDWWmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:42:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59737 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbYDWWmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:42:32 -0400
Message-ID: <480FBA73.2090209@zytor.com>
Date: Wed, 23 Apr 2008 15:38:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
References: <200804181856.m3IIuKd4007403@hera.kernel.org> <1208917076.9212.721.camel@pmac.infradead.org> <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com> <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com> <480F7C11.8040302@zytor.com> <20080423185859.GB7713@cvg>
In-Reply-To: <20080423185859.GB7713@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> 
> Peter, Ingo,
> 
> any objections on the patch like that?
> 

Well, I would prefer to try to get rid of them; as you said, most 
userland don't rely on these, and if they aren't used they are just 
namespace pollution, and rather bad such.

	-hpa
