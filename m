Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863AbZIIDdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbZIIDdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbZIIDdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:33:46 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:1194 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZIIDdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:33:45 -0400
Date: Tue, 8 Sep 2009 23:32:37 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       lrodriguez@atheros.com, mickflemm@gmail.com, jirislaby@gmail.com,
       linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: [PATCH] ath5k: do not free irq after resume when card has been
	removed
Message-ID: <20090909033237.GC13550@hash.localnet>
References: <1252457551-4909-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252457551-4909-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 09:52:31PM -0300, Thadeu Lima de Souza Cascardo wrote:
> ath5k will try to request irq when resuming and fails if the device
> (like a PCMCIA card) has been removed.

That's not true, ath5k no longer requests an irq when resuming.

> This solves this issue defining a new flag for the status bitmap to
> indicate when irq has been successfully requested and does not try to
> release it if not.

I'd rather not fix it with a status bit.  What kernel is this against?

-- 
Bob Copeland %% www.bobcopeland.com

