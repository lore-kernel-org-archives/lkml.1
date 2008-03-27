Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYC0Iez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYC0Iez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756002AbYC0Iep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:34:45 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51745 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbYC0Ieo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:34:44 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080326225112.GW10722@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 26 Mar 2008 22:51:12 +0000)
Subject: Re: [patch 7/7] vfs: mountinfo: show dominating group id
References: <20080326211131.705321084@szeredi.hu> <20080326212144.764829833@szeredi.hu> <20080326225112.GW10722@ZenIV.linux.org.uk>
Message-Id: <E1JenYk-0006xO-GD@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 27 Mar 2008 09:34:06 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static struct vfsmount *get_peer_under_root(struct vfsmount *mnt,
> > +					    struct mnt_namespace *ns,
> 
> Isn't it mnt->mnt_ns in all cases?

Nope.

Miklos
