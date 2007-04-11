Return-Path: <linux-kernel-owner+w=401wt.eu-S966039AbXDKBpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966039AbXDKBpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 21:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966052AbXDKBpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 21:45:35 -0400
Received: from quechua.inka.de ([193.197.184.2]:50166 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966039AbXDKBpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 21:45:34 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: If not readdir() then what?
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <1176250921.309.94.camel@heimdal.trondhjem.org>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HbRts-0000DI-00@calista.eckenfels.net>
Date: Wed, 11 Apr 2007 03:45:32 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <1176250921.309.94.camel@heimdal.trondhjem.org> you wrote:
> Otherwise, the client would have to cache _all_ previous READDIR results
> since the last opendir()/rewinddir() in order to be able to do its own
> loop detection and that will obviously never scale for large directories
> or for directories that change frequently...

Unless you have a COW style filesystem with versioning (think oracle tables)
you will have to invalidate cookies often or do copies - on client or
server. And I am not sure whats worse (for apps)... disappearing/missing
files or duplicates.

Gruss
bernd
