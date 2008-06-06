Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYFFEtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYFFEtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 00:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYFFEtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 00:49:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47824 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYFFEtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 00:49:16 -0400
Date: Thu, 5 Jun 2008 21:45:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Stable Kernel <stable@kernel.org>
Subject: Re: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
Message-ID: <20080605214536.0e289ebb@infradead.org>
In-Reply-To: <4848046A.5060006@goop.org>
References: <4848046A.5060006@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2008 16:21:14 +0100
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> When a 64-bit x86 processor runs in 32-bit PAE mode, a pte can
> potentially have the same number of physical address bits as the
> 64-bit host ("Enhanced Legacy PAE Paging").
> 

the problem on 32 bit is that if you have that much ram, you run out of
lowmem FAST.... so you have bigger problems.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
