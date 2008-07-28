Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYG1XI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYG1XI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbYG1XIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:08:19 -0400
Received: from ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk ([217.169.26.28]:55926
	"EHLO ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbYG1XIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:08:18 -0400
Date: Tue, 29 Jul 2008 00:05:33 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Char: ds1286, eliminate busy waiting
Message-ID: <20080728230533.GB1430@linux-mips.org>
References: <1217008198-17143-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217008198-17143-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 07:49:58PM +0200, Jiri Slaby wrote:

> ds1286_get_time(); is not called from atomic context, sleep for 20 ms is
> better choice than a (home-made) busy waiting for such a situation.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Ralf Baechle <ralf@linux-mips.org>

Looks ok to me I guess.  Though I don't really think it matters ...

Acked-by: Ralf Baechle <ralf@linux-mips.org>

The same condition also appears in drivers/char/rtc.c and maybe a few
others.  Rtc.c has been copies and modified several times.

  Ralf
