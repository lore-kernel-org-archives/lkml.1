Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZLTVZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZLTVZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 16:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756083AbZLTVZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 16:25:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:48357 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbZLTVZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 16:25:16 -0500
Date: Sun, 20 Dec 2009 21:25:15 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/compat_ioctl.c: fix build error when !BLOCK
Message-ID: <20091220212515.GP18217@ZenIV.linux.org.uk>
References: <1261344092-30700-1-git-send-email-a.beregalov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261344092-30700-1-git-send-email-a.beregalov@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 12:21:32AM +0300, Alexander Beregalov wrote:
> Fix this build error when CONFIG_BLOCK is not set.
> fs/compat_ioctl.c:1604: error: 'SG_SET_TRANSFORM' undeclared

Do you want that through VFS tree?  I'm going to send a bunch of assorted
fixes tomorrow morning, so I can pass that one at the same time...
