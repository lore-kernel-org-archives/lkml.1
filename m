Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbXLZCMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbXLZCMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 21:12:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbXLZCMC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 21:12:02 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:46953 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbXLZCMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 21:12:00 -0500
Subject: Re: [BUG 2.6.24-rc6-mm1] BUG() at check_irqs_on() in fs/buffer.c .
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071223151656.GA18738@elte.hu>
References: <200712232212.GII90159.tFFVSOLFJHQOOM@I-love.SAKURA.ne.jp>
	 <20071223151656.GA18738@elte.hu>
Content-Type: text/plain
Date: Tue, 25 Dec 2007 18:10:09 -0800
Message-Id: <1198635010.2742.40.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-12-23 at 16:16 +0100, Ingo Molnar wrote:
> * Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> 
> > Hello.
> > 
> > I encountered a BUG().
> > I didn't encounter this bug for 2.6.24-rc5-mm1 .
> > I guess this bug was introduced between 2.6.24-rc5-mm1 and 2.6.24-rc6-mm1 .
> 
> does the patch below help?
> 

I had a slightly different stack trace, and the patch supplied fix the
issue for me also.

Daniel

