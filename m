Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYIUTPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYIUTPZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYIUTPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:15:12 -0400
Received: from quechua.inka.de ([193.197.184.2]:37973 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbYIUTPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:15:12 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] log fatal signals like SIGSEGV
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <18646.39701.819497.337394@harpo.it.uu.se>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1KhUOj-0003x9-00@calista.eckenfels.net>
Date: Sun, 21 Sep 2008 21:15:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <18646.39701.819497.337394@harpo.it.uu.se> you wrote:
>   Applications that handle SEGV/BUS/ILL/FPE aren't that uncommon.

JRE uses SIGSEGV for (expected) NullPointers. So you might see a lot of
those on the logs. However: not in all cases you dont want to log handled
(fatal) signals. Not sure how to detect those. Maybe it is better to fix
applications and remove their home grown crash logging.

Gruss
Bernd
