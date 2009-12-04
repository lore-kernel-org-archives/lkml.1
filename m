Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbZLDHMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbZLDHMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 02:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZLDHMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 02:12:07 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48273 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZLDHMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 02:12:05 -0500
To: Eric Paris <eparis@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       npiggin@suse.de, eparis@redhat.com, zohar@us.ibm.com, jack@suse.cz,
       jmalicki@metacarta.com, dsmith@redhat.com, serue@us.ibm.com, hch@lst.de,
       john@johnmccutchan.com, rlove@rlove.org, ebiederm@xmission.com,
       heiko.carstens@de.ibm.com, penguin-kernel@I-love.SAKURA.ne.jp,
       mszeredi@suse.cz, jens.axboe@oracle.com, akpm@linux-foundation.org,
       matthew@wil.cx, hugh.dickins@tiscali.co.uk,
       kamezawa.hiroyu@jp.fujitsu.com, nishimura@mxp.nes.nec.co.jp,
       davem@davemloft.net, arnd@arndb.de, eric.dumazet@gmail.com
In-reply-to: <20091203195933.8925.8783.stgit@paris.rdu.redhat.com> (message
	from Eric Paris on Thu, 03 Dec 2009 14:59:33 -0500)
Subject: Re: [RFC PATCH 6/6] fs: move get_empty_filp() deffinition to internal.h
References: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com> <20091203195933.8925.8783.stgit@paris.rdu.redhat.com>
Message-Id: <E1NGSKh-0004ov-4y@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 04 Dec 2009 08:12:03 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009, Eric Paris wrote:
> All users outside of fs/ of get_empty_filp() have been removed.  This patch
> moves the definition from the include/ directory to internal.h so no new
> users crop up and removes the EXPORT_SYMBOL.  I'd love to see open intents
> stop using it too, but that's a problem for another day and a smarter
> developer!

ACK for 5/6 and 6/6.

Thanks,
Miklos
