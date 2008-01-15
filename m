Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYAOKbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYAOKbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751173AbYAOKbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:31:31 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45448 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYAOKba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:31:30 -0500
To: serue@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, ebiederm@xmission.com,
       kzak@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       util-linux-ng@vger.kernel.org
In-reply-to: <20080114232419.GH6704@sergelap.austin.ibm.com>
	(serue@us.ibm.com)
Subject: Re: [patch 7/9] unprivileged mounts: allow unprivileged fuse mounts
References: <20080108113502.184459371@szeredi.hu> <20080108113630.861045063@szeredi.hu> <20080114232419.GH6704@sergelap.austin.ibm.com>
Message-Id: <E1JEj3N-0000vj-QA@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 15 Jan 2008 11:29:57 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sounds like a sysctl to enable FS_SAFE for fuse will make this patch
> acceptable to everyone?

I think the most generic approach, is to be able to set "safeness" for
any fs type, not just fuse (Karel's suggestion).

E.g:

  echo 1 > /proc/sys/fs/types/cifs/safe

This would also provide a way to query the FS_SAFE flag.

Miklos
