Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab0BRLAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 06:00:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60951 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0BRLAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 06:00:53 -0500
Subject: Re: [PATCH 09/10] x86-32: use SSE for atomic64_read/set if
 available
From: Peter Zijlstra <peterz@infradead.org>
To: Luca Barbieri <luca@luca-barbieri.com>
Cc: mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ff13bc9a1002180250t5c9acb54ib8609b4e752520c5@mail.gmail.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
	 <1266406962-17463-10-git-send-email-luca@luca-barbieri.com>
	 <1266488742.26719.119.camel@laptop>
	 <ff13bc9a1002180250t5c9acb54ib8609b4e752520c5@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 12:00:46 +0100
Message-ID: <1266490846.26719.206.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 11:50 +0100, Luca Barbieri wrote:
> If we use the stack instead of per-CPU variables, all IRQs and NMIs
> preserve CR0 and the SSE registers, so this would be safe, right?

You'd have to take special care to deal with nested IRQs I think.

