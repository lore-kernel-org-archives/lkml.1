Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYKSAUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYKSAUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 19:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYKSAUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 19:20:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60635 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750907AbYKSAUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 19:20:15 -0500
Date: Tue, 18 Nov 2008 16:19:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] udf: reduce stack usage of udf_get_filename
Message-Id: <20081118161938.e415c6bc.akpm@linux-foundation.org>
In-Reply-To: <20081116180240.GB6282@joi>
References: <20081116180240.GB6282@joi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 19:02:45 +0100
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> +	filename = kmalloc(sizeof(struct ustr), GFP_NOFS);

I suspect that we could have used the superior GFP_KERNEL everywhere in
both these patches.  But I'll let Jan worry about that ;)

