Return-Path: <linux-kernel-owner+w=401wt.eu-S1759033AbYHUVDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbYHUVDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYHUVDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:03:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49763
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752762AbYHUVDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:03:47 -0400
Date: Thu, 21 Aug 2008 14:03:46 -0700 (PDT)
Message-Id: <20080821.140346.236252915.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] math-emu: Fix compiler warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <1219323021-7273-1-git-send-email-galak@kernel.crashing.org>
References: <1219323021-7273-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Thu, 21 Aug 2008 07:50:20 -0500

> Fix warnings of the form:
> arch/powerpc/math-emu/fsubs.c:15: warning: 'R_f1' may be used uninitialized in this function
> arch/powerpc/math-emu/fsubs.c:15: warning: 'R_f0' may be used uninitialized in this function
> 
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

You should look at the compiler options we use on sparc to build this
stuff :-)

EXTRA_CFLAGS = -Iinclude/math-emu -w
