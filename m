Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbYJTGd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbYJTGd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 02:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbYJTGdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 02:33:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32883
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbYJTGdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 02:33:44 -0400
Date: Sun, 19 Oct 2008 23:33:21 -0700 (PDT)
Message-Id: <20081019.233321.69192797.davem@davemloft.net>
To: andrea@persephoneslair.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race in arch/sparc64/kernel/trampoline.S
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081018000635.GA16445@charon.persephoneslair.org>
References: <20081018000635.GA16445@charon.persephoneslair.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrea Shepard <andrea@persephoneslair.org>
Date: Fri, 17 Oct 2008 17:06:35 -0700

> Make arch/sparc64/kernel/trampoline.S in 2.6.27.1 lock prom_entry_lock
> when calling the PROM.  This prevents a race condition that I observed
> causing a hang on startup on a 12-CPU E4500.
> 
> I am not subscribed to this list, so please CC me on replies.
> 
> Signed-off-by: Andrea Shepard <andrea@persephoneslair.org>

Applied, thanks a lot Andrea.
