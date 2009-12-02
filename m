Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbZLBJWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbZLBJWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 04:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbZLBJWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 04:22:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZLBJWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 04:22:38 -0500
Message-ID: <4B16318E.7010504@gmail.com>
Date: Wed, 02 Dec 2009 10:21:18 +0100
From: Edward Shishkin <edward.shishkin@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: Johannes Buchner <buchner.johannes@gmx.at>
CC: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: reiser4: newbie help needed?
References: <20091202192143.48ece851.buchner.johannes@gmx.at>
In-Reply-To: <20091202192143.48ece851.buchner.johannes@gmx.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Buchner wrote:
> Hi!
>
> I am possibly interested in helping out. Who is currently working on
> reiser4?

Nobody.
Because there is no bugreports.

>  I took a look at the TODO lists, are there any simple tasks to
> do for newbies?
>   

If you mean the "todo for inclusion", then no.

Reiser4 has only one technical issue. It can
be resolved only by very experienced people.

> Also, where is the latest code development going on?
>   

in -mm

> I also believe that on 'sync', reiser4 currently does absolutely
> nothing.

this is not good: a file system should respond on sync (1).

>  The comment in reiser4_sync_inodes says reiser4 does its own
> flush elsewhere. Should this be different?
>   

you might want to ask such question _before_ sending patches to akpm. 

BTW excellent comment, what is not clear?

/**
 * reiser4_sync_inodes - sync_inodes of super operations
 * @super:
 * @wbc:
 *
 * This method is called by background and non-backgound writeback. 
Reiser4's
 * implementation uses generic_sync_sb_inodes to call reiser4_writepages for
 * each of dirty inodes. Reiser4_writepages handles pages dirtied via shared
 * mapping - dirty pages get into atoms. Writeout is called to flush some
 * atoms.
 */
 
Edward.
