Return-Path: <linux-kernel-owner+w=401wt.eu-S1751542AbXEXPy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbXEXPy5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXEXPys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:54:48 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:47216 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbXEXPyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:54:47 -0400
Date: Thu, 24 May 2007 17:53:54 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Mike Frysinger <vapier@gentoo.org>
cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] use POSIX equality test in check-lxdialog.sh
In-Reply-To: <200705232137.45762.vapier@gentoo.org>
Message-ID: <Pine.LNX.4.61.0705241752491.31549@yvahk01.tjqt.qr>
References: <200705232137.45762.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 23 2007 21:37, Mike Frysinger wrote:

>The "==" operator is not in POSIX, so use -eq instead.

Apart from that, == is for strings, -eq is for numbers,
so that wrong variable content can be caught
("$x" -eq 123 where x=123foo throws an error).

So yes, the patch is good.

	Jan
-- 
