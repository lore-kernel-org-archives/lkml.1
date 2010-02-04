Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab0BDSse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:48:34 -0500
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:35665 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757529Ab0BDSsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:48:32 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-07.arcor-online.net 1CB553CA247
From: Bodo Eggert <7eggert@web.de>
Subject: Re: [RFC PATCH] vfs: add MNT_NOFOLLOW flag to umount(2)
To: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Reply-To: 7eggert@gmx.de
Date: Thu, 04 Feb 2010 19:48:25 +0100
References: <eae9I-mz-1@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Nd6kb-000458-Ne@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Additionally, return -EINVAL if an unknown flag is encountered.  This
> makes it possible for the caller to determine if a flag is supported
> or not (at least on kernels with this patch).

There should be a guaranteed-to-be-invalid flag or flag-combination in
order to safely detect this feature.

