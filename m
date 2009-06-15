Return-Path: <linux-kernel-owner+w=401wt.eu-S1752674AbZFOJZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674AbZFOJZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 05:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbZFOJZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 05:25:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56760
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752053AbZFOJZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 05:25:44 -0400
Date: Mon, 15 Jun 2009 02:25:47 -0700 (PDT)
Message-Id: <20090615.022547.107684868.davem@davemloft.net>
To: tiwai@suse.de
Cc: bzolnier@gmail.com, sven.koehler@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: sound skipping regression introduced in 2.6.30-rc8
From: David Miller <davem@davemloft.net>
In-Reply-To: <s5h63exevqh.wl%tiwai@suse.de>
References: <200906121344.26139.bzolnier@gmail.com>
	<s5h7hzdew6u.wl%tiwai@suse.de>
	<s5h63exevqh.wl%tiwai@suse.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>
Date: Mon, 15 Jun 2009 10:39:50 +0200

> If that patch also doesn't work, we need to track the position update
> sequence in more details.
> The patch below will dump the each position update (CAUTION: it can be
> long logs!).  Please apply it instead of the previous one, run with
> xrun_debug=5 on 2.6.31 (or xrun_debug=1 on 2.6.30), and give the
> outputs around a skip occurs.

The patch doesn't work.

I put up a debugging log at:

	http://vger.kernel.org/~davem/asound.log

there is a "PCM: hw_ptr skipping! ..." message near the end.
