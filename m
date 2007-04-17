Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbXDQKrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbXDQKrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 06:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbXDQKrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 06:47:05 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:44949 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbXDQKrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 06:47:03 -0400
To: serue@us.ibm.com
CC: akpm@linux-foundation.org, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
In-reply-to: <20070416192050.GB30435@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 05/10] Add "permit user submounts" flag to vfsmount
References: <20070416110308.739051445@szeredi.hu> <20070416110414.591968270@szeredi.hu> <20070416192050.GB30435@sergelap.austin.ibm.com>
Message-Id: <E1HdlAt-00013a-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 17 Apr 2007 12:44:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > If MNT_USERMNT flag is not set in the target vfsmount, then
> 
> MNT_USER and MNT_USERMNT?  I claim no way will people keep those
> straight.  How about MNT_ALLOWUSER and MNT_USER?

Umm, is "allowuser" more clear than "usermnt"?  What is allowed to the
user?  "allowusermnt" may be more descriptive, but it's a bit too
long.

I don't think it matters all that much, the user will have to look up
the semantics in the manpage anyway.  Is "nosuid" descriptive?  Not
very much, but we got used to it.

Miklos
