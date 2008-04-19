Return-Path: <linux-kernel-owner+w=401wt.eu-S1762048AbYDSO6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762048AbYDSO6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 10:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbYDSO6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 10:58:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:49774 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbYDSO6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 10:58:45 -0400
Cc: vitb@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Message-Id: <670559C8-CDD2-42A3-BF8A-E5521E5DC411@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Jeff Garzik <jeff@garzik.org>
In-Reply-To: <633e3f1106fd888b93a0f18c73449fd86054cc05.1208559659.git.jgarzik@redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 04/15] [PPC] minor irq handler cleanups
Date: Sat, 19 Apr 2008 09:57:55 -0500
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <633e3f1106fd888b93a0f18c73449fd86054cc05.1208559659.git.jgarzik@redhat.com>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 18, 2008, at 6:22 PM, Jeff Garzik wrote:
> - whitespace cleanups
>
> - remove pointless prototype (uses always follow func implementation)
>
> - 'irq' argument is often used purely as a local variable.  rename
>  argument to 'dummy' and define 'irq' as local to make this plain.
>
> - remove pointless casts from void*
>
> This change's main purpose is to prepare for the patchset in
> jgarzik/misc-2.6.git#irq-remove, that explores removal of the
> never-used 'irq' argument in each interrupt handler.
>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

arch/ppc is pretty much left for dead at this point.  I'm guessing we  
will end up removing it 2.6.27 if we follow through with our plans of  
killing it this summer.

Acked-by: Kumar Gala <galak@kernel.crashing.org>

- k
