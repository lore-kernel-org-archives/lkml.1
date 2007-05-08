Return-Path: <linux-kernel-owner+w=401wt.eu-S1032242AbXEHVLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032242AbXEHVLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1032233AbXEHVLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:11:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032193AbXEHVK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:10:56 -0400
Date: Tue, 8 May 2007 14:10:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Latchesar Ionkov" <lucho@ionkov.net>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "V9FS Developers" <v9fs-developer@lists.sourceforge.net>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] v9fs: rename non-vfs related structs and functions
 to be moved to net/9p
Message-Id: <20070508141012.7fdf4c24.akpm@linux-foundation.org>
In-Reply-To: <f158dc670705081351j4d46b433o2bdd2e8212a52e15@mail.gmail.com>
References: <f158dc670705081351j4d46b433o2bdd2e8212a52e15@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007 14:51:02 -0600
"Latchesar Ionkov" <lucho@ionkov.net> wrote:

> This patchset moves non-filesystem interfaces of v9fs from fs/9p to net/9p.
> It moves the transport, packet marshalling and connection layers to net/9p
> leaving only the VFS related files in fs/9p.

(Please cc netdev@vger.kernel.org on net-related work)

These changes would be best handled via Eric's git tree, with appropriate
acks from the net maintainers.
