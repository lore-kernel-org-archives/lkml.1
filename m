Return-Path: <linux-kernel-owner+w=401wt.eu-S1753732AbXFPPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbXFPPoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 11:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbXFPPoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 11:44:11 -0400
Received: from wine.ocn.ne.jp ([220.111.47.146]:49373 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbXFPPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 11:44:10 -0400
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,pathname matching
From: Tetsuo Handa <from-lsm@I-love.SAKURA.ne.jp>
References: <20070514110607.549397248@suse.de>
	<200706090003.57722.agruen@suse.de>
	<20070609001703.GA17644@kroah.com>
	<466C303E.5010304@novell.com>
	<20070615165054.GA11345@kroah.com>
In-Reply-To: <20070615165054.GA11345@kroah.com>
Message-Id: <200706170044.DJF02182.TtMPNGNS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Sun, 17 Jun 2007 00:44:08 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> A daemon using inotify can "instantly"[1] detect this and label the file
> properly if it shows up.

> Same daemon can do the re-label.

Can the daemon using inotify access to all pathnames in all process's namespaces?
Are the namespace the daemon has and the namespace of pathnames notified via inotify always the same?
