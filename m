Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbXJGSeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbXJGSeN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 14:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbXJGSd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 14:33:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:45687 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbXJGSd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 14:33:57 -0400
Subject: Re: Sleeping in RCU list traversal
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: junwang1234@gmail.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <200710080156.IFB56934.tHMLFFJSFOVOOQ@I-love.SAKURA.ne.jp>
References: <1191784307.3618.8.camel@localhost.localdomain>
	 <200710072226.EJF51558.LFVHJOStFOOFMQ@I-love.SAKURA.ne.jp>
	 <1191796640.3045.25.camel@localhost.localdomain>
	 <200710080156.IFB56934.tHMLFFJSFOVOOQ@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Sun, 07 Oct 2007 20:33:16 +0200
Message-Id: <1191781996.5587.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-10-08 at 01:56 +0900, Tetsuo Handa wrote:

> So, I don't need to grab a reference to "ptr"
> because memory region pointed by "ptr" will never be kfree()ed.
> And it is legal to use "ptr" after rcu_read_unlock()
> because memory region pointed by "ptr" will never be kfree()ed.

Still think that is a very BAD (tm) idea. Esp since with the help of RCU
there is hardly any performance loss of not doing proper deletes.


