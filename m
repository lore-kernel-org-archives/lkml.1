Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbYICSqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbYICSqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756670AbYICSpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:45:36 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43889 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbYICSpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:45:35 -0400
To: serue@us.ibm.com
CC: miklos@szeredi.hu, ebiederm@xmission.com, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080827184600.GA8069@us.ibm.com> (serue@us.ibm.com)
Subject: Re: unprivileged mounts git tree
References: <E1JtiOX-0004Qg-1z@pomaz-ex.szeredi.hu> <20080807222751.GA28412@us.ibm.com> <m1prokgyje.fsf@frodo.ebiederm.org> <20080808002537.GA5364@us.ibm.com> <E1KXZpC-0008Ie-6w@pomaz-ex.szeredi.hu> <20080827153628.GA11242@us.ibm.com> <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu> <20080827184600.GA8069@us.ibm.com>
Message-Id: <E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 03 Sep 2008 20:45:06 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Serge E. Hallyn wrote:
> Ok, thanks.  I look forward to playing around with it when you publish
> the resulting git tree  :)

A couple of centuries later...

...here's the updated git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git unprivileged-mounts

Changes since the previous version:

 - update to apply against latest git
 - downgrade shared mounts to slave for unprivileged binds (if owners differ)
 - don't allow unprivileged recursive binds

Serge, thanks again for testing and reviewing these patches!

Miklos
