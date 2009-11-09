Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZKIOpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZKIOpL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 09:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZKIOpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 09:45:08 -0500
Received: from THUNK.ORG ([69.25.196.29]:36374 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbZKIOpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 09:45:05 -0500
Date: Mon, 9 Nov 2009 09:45:01 -0500
From: Theodore Tso <tytso@mit.edu>
To: Jan Blunck <jblunck@suse.de>
Cc: linux-fsdevel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 08/27] BKL: Remove BKL from ext4 filesystem
Message-ID: <20091109144500.GA11942@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jan Blunck <jblunck@suse.de>, linux-fsdevel@vger.kernel.org,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>, Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4@vger.kernel.org
References: <1257156307-24175-1-git-send-email-jblunck@suse.de> <1257156307-24175-9-git-send-email-jblunck@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257156307-24175-9-git-send-email-jblunck@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:04:48AM +0100, Jan Blunck wrote:
> The BKL is still used in ext4_put_super(), ext4_fill_super() and
> ext4_remount(). All three calles are protected against concurrent calls by
> the s_umount rw semaphore of struct super_block.
> 
> Therefore the BKL is protecting nothing in this case.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted
