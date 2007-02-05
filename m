Return-Path: <linux-kernel-owner+w=401wt.eu-S933460AbXBEVx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbXBEVx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:53:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933500AbXBEVx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:53:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46503 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933460AbXBEVx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:53:27 -0500
Subject: Re: [patch] MTD: fix DOC2000/2001/2001PLUS build error
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
	 <20070205084523.GA21858@elte.hu>
	 <1170682488.29759.795.camel@pmac.infradead.org>
	 <20070205155627.GA8354@elte.hu>
	 <1170692539.29759.856.camel@pmac.infradead.org>
	 <20070205162635.GA755@elte.hu> <20070205163152.GA2464@elte.hu>
	 <Pine.LNX.4.64.0702050852160.8424@woody.linux-foundation.org>
	 <1170710272.29759.894.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051322580.8424@woody.linux-foundation.org>
	 <1170711587.29759.909.camel@pmac.infradead.org>
	 <Pine.LNX.4.64.0702051345380.8424@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 21:53:13 +0000
Message-Id: <1170712393.29759.925.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-05 at 13:49 -0800, Linus Torvalds wrote:
> Can you read? Can you UNDERSTAND?
> 
> This is exactly my point.
> 
> If it's not obviously a SCSI card, then it shouldn't be "depends on SCSI". 
> It should be on its own and "select SCSI".
> 
> The whole AND ALMOST ONLY point of "depends on" is really to allow people 
> to do a shorthand or know that "ok, he gave us some information that makes 
> this choice pointless". 

You're asking _me_ if I can read?

Ten years ago, people used 'depends on' to fix the tools, so that then
you want to enable something like USB_STORAGE, it can automatically turn
SCSI on for you.

Isn't that what you wanted?

You don't need to screw over the technical users -- the _common_ case --
in order to achieve that.

We had it. TEN YEARS AGO. In the tools.

-- 
dwmw2

