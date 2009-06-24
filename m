Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZFXJAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZFXJAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbZFXJAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:00:43 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43866
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752649AbZFXJAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:00:42 -0400
Date: Wed, 24 Jun 2009 02:00:47 -0700 (PDT)
Message-Id: <20090624.020047.175924588.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
       mingo@elte.hu, kyle@mcmartin.ca, cl@linux-foundation.org,
       Jesper.Nilsson@axis.com, benh@kernel.crashing.org,
       paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH 11/10] sparc64: fix build breakage introduced by
 percpu-convert-most patchset
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A41DDE6.1090209@kernel.org>
References: <1245825924-30412-1-git-send-email-tj@kernel.org>
	<4A41DDE6.1090209@kernel.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Wed, 24 Jun 2009 17:03:50 +0900

> Commit e74e396204bfcb67570ba4517b08f5918e69afea incorrectly added
> added HAVE_LEGACY_PER_CPU_AREA to sparc64 although it already has been
> converted to dynamic percpu allocator.  Drop both
> HAVE_{LEGACY|DYNAMIC}_PER_CPU_AREA.
> 
> [ Impact: fix build breakage ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: David S. Miller <davem@davemloft.net>
