Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbZKROqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbZKROqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbZKROq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:46:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:34855 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757239AbZKROq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:46:28 -0500
Date: Wed, 18 Nov 2009 23:40:27 +0900 (JST)
Message-Id: <20091118.234027.88666093.ryusuke@osrg.net>
To: jblunck@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jkacur@redhat.com, tglx@linutronix.de,
       hch@infradead.org, arnd@arndb.de, matthew@wil.cx,
       konishi.ryusuke@lab.ntt.co.jp
Subject: Re: [PATCH 15/20] BKL: Remove BKL from NILFS2
From: Ryusuke Konishi <ryusuke@osrg.net>
In-Reply-To: <1258536293-7762-16-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
	<1258536293-7762-16-git-send-email-jblunck@suse.de>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 18 Nov 2009 23:40:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Nov 2009 10:24:48 +0100, Jan Blunck <jblunck@suse.de> wrote:
> The BKL is only used in put_super, fill_super and remount_fs that are all
> three protected by the superblocks s_umount rw_semaphore. Therefore it is
> safe to remove the BKL entirely.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>

All right, thanks.

Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>

Ryusuke Konishi
