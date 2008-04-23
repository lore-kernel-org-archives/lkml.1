Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbYDWWsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbYDWWsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYDWWsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:48:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54315 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbYDWWsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:48:10 -0400
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
From: David Woodhouse <dwmw2@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <480FBA73.2090209@zytor.com>
References: <200804181856.m3IIuKd4007403@hera.kernel.org>
	 <1208917076.9212.721.camel@pmac.infradead.org>
	 <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com>
	 <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com>
	 <480F7C11.8040302@zytor.com> <20080423185859.GB7713@cvg>
	 <480FBA73.2090209@zytor.com>
Content-Type: text/plain
Date: Wed, 23 Apr 2008 23:48:02 +0100
Message-Id: <1208990882.9212.855.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-23 at 15:38 -0700, H. Peter Anvin wrote:
> Cyrill Gorcunov wrote:
> > 
> > Peter, Ingo,
> > 
> > any objections on the patch like that?
> > 
> 
> Well, I would prefer to try to get rid of them; as you said, most 
> userland don't rely on these, and if they aren't used they are just 
> namespace pollution, and rather bad such.

Yeah, I'd prefer just to kill them off if we think we can get away with
it. These are hardware-defined flags, not Linux-specific, so userspace
should probably get them from elsewhere anyway.

-- 
dwmw2

