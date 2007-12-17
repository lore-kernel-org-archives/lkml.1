Return-Path: <linux-kernel-owner+w=401wt.eu-S935280AbXLQCM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935280AbXLQCM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932390AbXLQCMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:12:30 -0500
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:56542 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765954AbXLQCM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:12:29 -0500
X-Greylist: delayed 3177 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Dec 2007 21:12:28 EST
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [patch 1/2] [RFC] Simple tamper-proof device filesystem.
Date: Mon, 17 Dec 2007 01:19:30 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <fk4ir2$g11$1@taverner.cs.berkeley.edu>
References: <47650A4C.4000708@davidnewall.com> <200712162036.JAJ09389.OQOVtOHMFLFSFJ@I-love.SAKURA.ne.jp> <476512F1.5010701@davidnewall.com> <200712162103.IEC69233.FFOFOOtJMQHSLV@I-love.SAKURA.ne.jp>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1197854370 16417 128.32.168.222 (17 Dec 2007 01:19:30 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Mon, 17 Dec 2007 01:19:30 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa writes:
>When I attended at Security Stadium 2003 as a defense side,
>I was using devfs for /dev directory. The files in /dev directory
>were deleted by attckers and the administrator was unable to login.

If the attacker gets full administrator-level access on your machine,
there are a gazillion ways the attacker can prevent other admins from
logging on.  This patch can't prevent that.  It sounds like this patch
is trying to solve a fundamentally unsolveable problem.

A useful slogan: "Don't forbid what you cannot prevent."
