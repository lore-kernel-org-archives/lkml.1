Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbZDGAn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbZDGAn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 20:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZDGAnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 20:43:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46989
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752356AbZDGAnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 20:43:45 -0400
Date: Mon, 06 Apr 2009 17:43:34 -0700 (PDT)
Message-Id: <20090406.174334.154575716.davem@davemloft.net>
To: tilman@imap.cc
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, hjlipp@web.de
Subject: Re: [PATCH 1/3] bas_gigaset: use tasklet_hi_schedule for timing
 critical tasklets
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090404-patch-01.tilman@imap.cc>
References: <20090404-patch-00.tilman@imap.cc>
	<20090404-patch-01.tilman@imap.cc>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tilman Schmidt <tilman@imap.cc>
Date: Sun,  5 Apr 2009 18:39:33 +0200 (CEST)

> The tasklets for isochronous data transfer need to run within 8 msec
> to avoid over/underruns, so schedule them with high priority to fix
> reported issues with occasional over/underruns.
> 
> Signed-off-by: Tilman Schmidt <tilman@imap.cc>

Applied.
