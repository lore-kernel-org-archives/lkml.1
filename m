Return-Path: <linux-kernel-owner+w=401wt.eu-S1766930AbXDSSTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766930AbXDSSTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 14:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766932AbXDSSTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 14:19:54 -0400
Received: from quechua.inka.de ([193.197.184.2]:56779 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766930AbXDSSTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 14:19:53 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: AppArmor FAQ
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <Line.LNX.4.64.0704180935100.25495@d.namei>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HebEV-0004m9-00@calista.eckenfels.net>
Date: Thu, 19 Apr 2007 20:19:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <Line.LNX.4.64.0704180935100.25495@d.namei> you wrote:
> Perhaps -- until your httpd is compromised via a buffer overflow or 
> simply misbehaves due to a software or configuration flaw, then the 
> assumptions being made about its use of pathnames and their security 
> properties are out the window.

Hu? Even a compromised httpd (especially a compromised httpd) is bound to
the app armor policies. This means it cannot (for example) write to
/var/www/* - if it never needed to at normal/profiling time.

Gruss
Bernd
