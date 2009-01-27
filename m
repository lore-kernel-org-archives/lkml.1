Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZA0QUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZA0QUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZA0QT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:19:59 -0500
Received: from casper.infradead.org ([85.118.1.10]:60160 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbZA0QT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:19:59 -0500
Date: Tue, 27 Jan 2009 08:19:54 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: Checkpatch false positive?
Message-ID: <20090127081954.47609e46@infradead.org>
In-Reply-To: <20090127154904.GC8289@duck.suse.cz>
References: <20090127154904.GC8289@duck.suse.cz>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2009 16:49:05 +0100
Jan Kara <jack@suse.cz> wrote:

>   Hi,
> 
>   I've used checkpatch.pl to verify one of my patches. It complains:
> 
> ERROR: trailing statements should be on next line
> #167: FILE: fs/quota/quota_tree.c:249:
> +       for (i = 0, ddquot = buf + sizeof(struct qt_disk_dqdbheader);
> [...]
>              i++, ddquot += info->dqi_entry_size);
> 
>   But the code looks like:
>         for (i = 0, ddquot = buf + sizeof(struct qt_disk_dqdbheader);
>              i < qtree_dqstr_in_blk(info)
> && !qtree_entry_unused(info, ddquot); i++, ddquot +=
> info->dqi_entry_size);
> 

while tihs might be correct C... don't you think it would be much
better to actually have a statement here rather than cramming
everything into the for ?
