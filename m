Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbXH3DAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbXH3DAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 23:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbXH3DAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 23:00:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57300 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752257AbXH3DAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 23:00:11 -0400
X-Sasl-enc: Q+53e7AT+IZ17P+Lv4PtHf03xqquaKZ2HbQd1X8LqhZP 1188442810
Subject: Re: regression of autofs for current git?
From: Ian Kent <raven@themaw.net>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       autofs@linux.kernel.org, Adrian Bunk <bunk@kernel.org>
In-Reply-To: <20070829224754.GW26410@stusta.de>
References: <00f401c7ea7f$6db9fc80$492df580$@com>
	 <20070829224754.GW26410@stusta.de>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 11:00:04 +0800
Message-Id: <1188442804.4090.10.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 00:47 +0200, Adrian Bunk wrote:
> On Wed, Aug 29, 2007 at 01:58:58PM -0700, Hua Zhong wrote:
> 
> > Hi,
> 
> Hi Hua,
> 
> > I am wondering if this is a known issue, but I just built the current git
> > and several autofs mounts mysteriously disappeared. Restarting autofs could
> > fix some, but then lose others. 2.6.22 was fine.
> > 
> > Is there anything I could check other than bisect? (It may take some time
> > for me to get to it)
> 
> the commit below is the only autofs4 patch that went into the git tree 
> since 2.6.22.
> 
> Does reverting it fix your problems?

Maybe but there is an NFS change that appears to be in the current
2.6.23-rc kernel and doesn't seem to be in 2.6.22 that is known to break
some autofs maps and also breaks amd.

I can't seem to locate the commit just now.
In the meantime what version of user space autofs and nfs-utils are you
running?
And can you post your autofs maps please?

Ian




