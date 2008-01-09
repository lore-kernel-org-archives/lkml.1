Return-Path: <linux-kernel-owner+w=401wt.eu-S1755643AbYAILEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643AbYAILEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 06:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYAILEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 06:04:37 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:59100 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbYAILEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 06:04:36 -0500
To: bcasavan@sgi.com
Cc: netdev@vger.kernel.org, davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: AF_UNIX MSG_PEEK bug?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.BSF.1.00.0801081556580.24286@pkunk.americas.sgi.com>
In-Reply-To: <alpine.BSF.1.00.0801081556580.24286@pkunk.americas.sgi.com>
Message-Id: <200801092004.IJJ48416.FVQOtOLFSOJHMF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 9 Jan 2008 20:04:32 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Brent Casavant wrote:
> However, the program would occasionally get into a situation where
> a call to recv(sockfd, &buf, len, MSG_PEEK) returns some number
> of bytes less than the requested length, and persists in this state
> (i.e. retrying the call continues to return the same amount of data)
> even when more than sufficient data is known to have been successfully
> written to the socket.
Did you try MSG_WAITALL flag? See "man 2 recv".
A TCP socket handles data in bytes.
You cannot complain if the amount received by recv() is smaller than expected
unless you use MSG_WAITALL flag.

Thanks.
