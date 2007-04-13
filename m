Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbXDMHNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbXDMHNG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 03:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXDMHNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 03:13:06 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:41045 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbXDMHND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 03:13:03 -0400
To: ebiederm@xmission.com
CC: serue@us.ibm.com, containers@lists.osdl.org, viro@ftp.linux.org.uk,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       linuxram@us.ibm.com, linux-kernel@vger.kernel.org
In-reply-to: <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
Subject: Re: [patch 05/10] add "permit user mounts in new namespace" clone flag
References: <20070412164541.580374744@szeredi.hu>
	<20070412164620.588752236@szeredi.hu>
	<20070412203208.GG27772@sergelap.austin.ibm.com> <m1mz1cq3v6.fsf@ebiederm.dsl.xmission.com>
Message-Id: <E1HcFx1-0001Zr-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 13 Apr 2007 09:12:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Given the existence of shared subtrees allowing/denying this at the mount
> namespace level is silly and wrong.
> 
> If we need more than just the filesystem permission checks can we
> make it a mount flag settable with mount and remount that allows
> non-privileged users the ability to create mount points under it
> in directories they have full read/write access to.

OK, that makes sense.

> I don't like the use of clone flags for this purpose but in this
> case the shared subtress are a much more fundamental reasons for not
> doing this at the namespace level.

I'll drop the clone flag, and add a mount flag instead.

Thanks,
Miklos
