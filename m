Return-Path: <linux-kernel-owner+w=401wt.eu-S1758467AbXFPAss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758467AbXFPAss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754734AbXFPAsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:48:40 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:59956 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbXFPAsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:48:39 -0400
To: crispin@novell.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,pathname matching
From: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
References: <466C303E.5010304@novell.com>
	<20070615165054.GA11345@kroah.com>
	<20070615200623.GA2616@elf.ucw.cz>
	<20070615211157.GB7337@kroah.com>
	<46732124.80509@novell.com>
In-Reply-To: <46732124.80509@novell.com>
Message-Id: <200706160948.FEH12774.MTtPGSNN@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Sat, 16 Jun 2007 09:48:39 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Crispin Cowan wrote:
> In a smaller scale example, I want to share some files with a friend. I
> can't be bothered to set up a proper access control system, so I just mv
> the files to ~crispin/public_html/lookitme and in IRC say "get it now,
> going away in 10 minutes" and then move it out again. Yes, you can
> manually address this by running "restorecon ~crispin/public_html". But
> AA does this automatically without having to run any commands.
If you share ~crispin/public_html/lookitme by making a hard link,
does relabeling approach work?
I thought SELinux allows only one label for one file.
If AA (on the top of SELinux) tries to allow different permissions to
~crispin/public_html/lookitme and its original location,
either one of two pathnames won't be accessible as intended, will it?
