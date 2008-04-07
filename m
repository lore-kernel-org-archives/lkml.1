Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYDGPYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYDGPYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbYDGPYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:24:31 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:65490 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYDGPYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:24:30 -0400
Subject: Re: [TOMOYO #7 02/30] Internal functions prototypes for SAKURA
	andTOMOYO.
From: Daniel Walker <dwalker@mvista.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp
In-Reply-To: <200804072256.FCJ21869.MJFFOVQtFOHSOL@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
	 <20080404122357.420668479@I-love.SAKURA.ne.jp>
	 <1207322973.21308.52.camel@localhost.localdomain>
	 <200804072256.FCJ21869.MJFFOVQtFOHSOL@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 08:24:26 -0700
Message-Id: <1207581866.21308.123.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-07 at 22:56 +0900, Tetsuo Handa wrote:

> I see. I'll move it on next posting.
> Although people advised me to use standard doubly linked list,
> TOMOYO wants to use singly linked list because the elements are append only.
> If TOMOYO is allowed to use singly linked list, it can make the source code read lock free.

I was just suggesting that you move your singly linked list operations
into list.h . There are some other places in the kernel that use singly
linked lists, but they have open coded operations (for instance
tasklets) ..

Daniel

