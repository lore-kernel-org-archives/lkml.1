Return-Path: <linux-kernel-owner+w=401wt.eu-S933035AbXLPLg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035AbXLPLg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 06:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763831AbXLPLgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 06:36:15 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:53790 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759192AbXLPLgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 06:36:14 -0500
To: david@davidnewall.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200712161944.HEI26071.MOtOFLVHFSQFOJ@I-love.SAKURA.ne.jp>
	<200712161956.BJE32406.FOOHtQJLMFOSVF@I-love.SAKURA.ne.jp>
	<47650A4C.4000708@davidnewall.com>
	<200712162026.BFJ01924.tOFJSFOQMVHOLF@I-love.SAKURA.ne.jp>
	<47650C88.6040105@davidnewall.com>
In-Reply-To: <47650C88.6040105@davidnewall.com>
Message-Id: <200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 16 Dec 2007 20:36:12 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> > I meant that "/dev must be mounted for read-write mode"
> 
> Again, why?

You can mount / partition for read-only mode if you wish to do so.
But you cannot make /dev directory for read-only.
You won't be able to login to the system because /sbin/mingetty
fails to "chown/chmod" /dev/tty* if /dev is mounted for read-only mode.
