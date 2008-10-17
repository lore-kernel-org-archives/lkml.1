Return-Path: <linux-kernel-owner+w=401wt.eu-S1755162AbYJQOhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbYJQOhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYJQOhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:37:05 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:55210 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbYJQOhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:37:03 -0400
Date: Fri, 17 Oct 2008 23:37:11 +0900 (JST)
Message-Id: <20081017.233711.08319236.anemo@mba.ocn.ne.jp>
To: zhaolei@cn.fujitsu.com
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix debugfs_create_*'s error checking method for
 mips/kernel/
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <48F87323.6020303@cn.fujitsu.com>
References: <48F87323.6020303@cn.fujitsu.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 19:12:35 +0800, Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> debugfs_create_*() returns NULL if an error occurs, returns -ENODEV
> when debugfs is not enabled in the kernel.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Oh that was my fault.  Thank you for fixing it.

Acked-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
