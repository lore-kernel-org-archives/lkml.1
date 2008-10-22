Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbYJVLVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbYJVLVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 07:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbYJVLVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 07:21:35 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:59600 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYJVLVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 07:21:35 -0400
To: apw@shadowen.org
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: */ in string confuses checkpatch.pl
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200810210057.m9L0vQ7i012829@www262.sakura.ne.jp>
	<20081022075617.GA22344@brain>
	<20081022083141.GB22344@brain>
In-Reply-To: <20081022083141.GB22344@brain>
Message-Id: <200810222021.EEH69777.MOFOLSVtQJHFOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 22 Oct 2008 20:21:31 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andy Whitcroft wrote:
> Ok, I can see whats happened here.  Most of these \'s are extraneous.
> Without those I can reproduce this.  Its a bug in the 'comment is open
> at the start of hunk' detection.  I think I have updated this heuristic
> to cope wit this.  Could you try your original patch (I assume there was
> one) with the version below:
> 
>   http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing
> 
> Thanks for your report.
> 
> -apw
> 
It solved this problem.

By the way, I'm using checkpatch.pl for checking userland application.
It would be convenient if there is a option that omits some checks like
'# check for external initialisers.' and '# check for static initialisers.'

Thank you.
