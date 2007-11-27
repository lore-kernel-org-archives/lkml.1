Return-Path: <linux-kernel-owner+w=401wt.eu-S1758845AbXK0Uq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbXK0Uq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 15:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756617AbXK0Uqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 15:46:48 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49341 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752305AbXK0Uqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 15:46:48 -0500
Date: Tue, 27 Nov 2007 12:46:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, mwelinder@gmail.com, rlove@rlove.org,
       John McCutchan <ttb@tentacle.dhs.org>
Subject: Re: [PATCH] Send IN_ATTRIB events when link count changes
Message-Id: <20071127124640.6110ddfb.akpm@linux-foundation.org>
In-Reply-To: <20071126162758.GA856@duck.suse.cz>
References: <118833cc0711201911r3684937p38823649639e0a57@mail.gmail.com>
	<118833cc0711231154i588cf7c1gb99e050999af8632@mail.gmail.com>
	<20071126160043.GA5647@atrey.karlin.mff.cuni.cz>
	<118833cc0711260806x69fc2bb6n572f1e1253a201ef@mail.gmail.com>
	<20071126162758.GA856@duck.suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 17:27:58 +0100
Jan Kara <jack@suse.cz> wrote:

>   Hi Andrew,
> 
>   would you pick up this patch for testing in -mm? Thanks.
> 
> 								Honza
> 
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
> 
> ---
> 
> Send inotify events to the inode itself when its link count has changed.

Could we have a better changelog please?  What is the reason for making
this change?  What are the before-and-after effects upon inotify clients,
etc?

