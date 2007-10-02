Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbXJBOvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbXJBOvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 10:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbXJBOvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 10:51:00 -0400
Received: from mail.suse.de ([195.135.220.2]:37620 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843AbXJBOvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:51:00 -0400
To: James Morris <jmorris@namei.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
References: <4701F285.5000206@nttdata.co.jp> <4701F419.8080103@nttdata.co.jp>
	<Xine.LNX.4.64.0710020355260.6760@us.intercode.com.au>
	<200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>
	<Xine.LNX.4.64.0710020557170.21841@us.intercode.com.au>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Oct 2007 16:50:57 +0200
In-Reply-To: <Xine.LNX.4.64.0710020557170.21841@us.intercode.com.au>
Message-ID: <p73sl4t604u.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> writes:
> 
> All linked lists (at least, new ones) must use the standard kernel list
> API.

Really? Why? That rule is new to me.

Would also seem very limiting especially since the standard kernel lists
do not allow to express important patterns (like single linked lists) 

I don't think that is a requirement.

-Andi
