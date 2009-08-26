Return-Path: <linux-kernel-owner+w=401wt.eu-S932864AbZHZMZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbZHZMZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbZHZMZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:25:40 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:54339 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305AbZHZMZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:25:39 -0400
X-Greylist: delayed 1418 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 08:25:39 EDT
To: clement.lecigne@netasq.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] 8 bytes kernel memory disclosure in AppleTalk getsockname.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20090826111247.GA79673@clem1.netasq.com>
In-Reply-To: <20090826111247.GA79673@clem1.netasq.com>
Message-Id: <200908262101.DBJ57868.OHOFFVLQOtMFSJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 26 Aug 2009 21:01:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clement LECIGNE wrote:
> Here is a patch that zero the whole sockaddr_at structure before
> processing it. It should fix this bug.

Same kind of bug at http://lkml.org/lkml/2006/7/25/51 .
I wonder why not zero'ing sockaddr at the caller rather than
zero'ing at individual ->getname(). Doing so will save some lines.
