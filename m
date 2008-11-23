Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbYKWAQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbYKWAQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 19:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYKWAQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 19:16:00 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:53783 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbYKWAP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 19:15:59 -0500
To: adilger@sun.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Zero-clearing all zero-clearable bytes.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200811221236.FJE81778.LtMHOQFJFVFSOO@I-love.SAKURA.ne.jp>
	<20081122174406.GQ3186@webber.adilger.int>
In-Reply-To: <20081122174406.GQ3186@webber.adilger.int>
Message-Id: <200811230915.CII90122.SFtOMFQHOVLOFJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 23 Nov 2008 09:15:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Andreas Dilger wrote:
> Why would you fill the buffer with 0xff instead of 0?
> In fact no such program is needed, just "dd if=/dev/zero of=/{fs}/tmp"
> and then delete the file.
> 
To avoid that the /{fs}/tmp is created as a sparse file.

I want to clear not only not-in-use blocks but also in-use blocks,
while keeping files in /{fs}/tmp intact.

Regards.
