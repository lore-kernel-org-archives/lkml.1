Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbXKZQAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbXKZQAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755601AbXKZQAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:00:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:34891 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXKZQAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:00:45 -0500
Date: Mon, 26 Nov 2007 17:00:44 +0100
From: Jan Kara <jack@suse.cz>
To: Morten Welinder <mwelinder@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Inotify fails to send IN_ATTRIB events
Message-ID: <20071126160043.GA5647@atrey.karlin.mff.cuni.cz>
References: <118833cc0711201911r3684937p38823649639e0a57@mail.gmail.com> <118833cc0711231154i588cf7c1gb99e050999af8632@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <118833cc0711231154i588cf7c1gb99e050999af8632@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks bad, though:
> 
> include/linux/fsnotify.h:121: warning: passing argument 2 of
> 'audit_inode_child' from incompatible pointer type
> 
> Missing "->d_inode"?
  That's the difference between 2.6.22 and 2.6.24-git against which I
wrote the patch :).

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
