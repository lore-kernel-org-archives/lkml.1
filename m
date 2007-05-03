Return-Path: <linux-kernel-owner+w=401wt.eu-S1767454AbXECWkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767454AbXECWkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 18:40:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767460AbXECWkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 18:40:22 -0400
Received: from quechua.inka.de ([193.197.184.2]:48303 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767454AbXECWkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 18:40:22 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <20070503211450.GA3869@nifty>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HjjyF-00022D-00@calista.eckenfels.net>
Date: Fri, 04 May 2007 00:40:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20070503211450.GA3869@nifty> you wrote:
> For this particular case, Ted is probably right and the only place
> we'll ever see this insane poor man's pre-allocate pattern is from the
> Windows CIFS client, in which case fixing this in Samba makes sense -
> although I'm a bit horrified by the idea of writing 128K of zeroes to
> pre-allocate... oh well, it's temporary, and what we care about here
> is the read performance, more than the write performance.

What about an ioctl or advice to avoid holes? Which could be issued by
samba? Is that related to SetFileValidData and SetEndOfFile win32 functions?
What is the windows client calling, and what command is transmitted by smb?

Gruss
Bernd
