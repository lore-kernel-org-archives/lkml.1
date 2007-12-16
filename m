Return-Path: <linux-kernel-owner+w=401wt.eu-S933323AbXLPL04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbXLPL04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 06:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764502AbXLPL0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 06:26:46 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:50132 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbXLPL0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 06:26:45 -0500
To: david@davidnewall.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071216080441.435456586@I-love.SAKURA.ne.jp>
	<20071216080628.061470932@I-love.SAKURA.ne.jp>
	<200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp>
	<200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp>
	<47650A4C.4000708@davidnewall.com>
In-Reply-To: <47650A4C.4000708@davidnewall.com>
Message-Id: <200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 16 Dec 2007 20:26:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

David Newall wrote:
> Tetsuo Handa wrote:
> >  /dev needs to be writable, but this means that files on /dev might be
> >  tampered with.
> 
> I infer that you mean /dev needs to be writable by anyone, not by just 
> its owner or owner and group (conventionally root/root.)  This goes 
> against conventional wisdom, which is that /dev must be writable only by 
> the administrator.  Why do you say otherwise?
I didn't mean that "/dev is writable by everybody".
I meant that "/dev must be mounted for read-write mode"
(even if one wants to mount / for read-only mode).

Regards.
