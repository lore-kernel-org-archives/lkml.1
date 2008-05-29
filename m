Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYE2QdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYE2QdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbYE2Qc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:32:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43358 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbYE2Qc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:32:56 -0400
To: lcapitulino@mandriva.com.br
CC: casey@schaufler-ca.com, miklos@szeredi.hu, linux-kernel@vger.kernel.org
In-reply-to: <20080529131401.7429568d@mandriva.com.br>
	(lcapitulino@mandriva.com.br)
Subject: Re: 2.6.24-rc4: mount.ntfs-3g hangs when smack is enabled
References: <20080529131401.7429568d@mandriva.com.br>
Message-Id: <E1K1l3b-0008Rx-4i@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 29 May 2008 18:32:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  I'm not sure whether this is a smack problem, but Mandriva users are
> reporting that mount.ntfs-3g (ntfs driver, uses FUSE) hangs when
> they try to mount their NTFS partition.

Yes, this is a smack/fuse interaction problem.  Also see this thread:

  http://marc.info/?l=fuse-devel&m=120931855107469&w=2

Casey, you were CC-d on the last mail in that thread.  Did you miss
that?

Thanks,
Miklos
