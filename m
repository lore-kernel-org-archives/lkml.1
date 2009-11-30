Return-Path: <linux-kernel-owner+w=401wt.eu-S1753656AbZK3LR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656AbZK3LR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 06:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZK3LR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 06:17:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbZK3LR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 06:17:57 -0500
Date: Mon, 30 Nov 2009 12:17:56 +0100
From: Jan Kara <jack@suse.cz>
To: =?iso-8859-1?B?Suly6W15?= Cochoy <jeremy.cochoy@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
       Pavel Machek <pavel@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
       ronny.pretzsch@dfs.de, Corentin Chary <corentin.chary@gmail.com>
Subject: Re: [PATCH] fs/ext2: ext2_readdir comment about returns
Message-ID: <20091130111755.GB4240@quack.suse.cz>
References: <a229bc400911291530s51e1971do402e6441115d70ee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a229bc400911291530s51e1971do402e6441115d70ee@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Mon 30-11-09 00:30:55, Jérémy Cochoy wrote:
> From:Jeremy Cochoy <jeremy.cochoy@gmail.com>
> I submit a short correction about a comment in ext2/dir.c
> 
> (I've already send it but it wasn't the good patch format and i didn't
> cc the right people.)
> 
> PS: Please excuse me if I make mistakes with the netiquette, it's my
> first patch and i wich to send more useful patchs next time, without
> hurting your eyes.
  Thanks for the patch. I'd like to point you to the
Documentation/SubmittingPatches document where is described how a proper
patch submission should look like. Most importantly I miss a Signed-off-by
line (item 12 in the document) - without it the patch cannot be merged.
Also your description in the subject is inaccurate. In my opinion it should
rather be:
ext2: Fixup description of ext2_find_entry
  Finally, it's easier to handle submitted patches with git tools when the
body of email looks like:
Something I want in the changelog additionally to mail subject line
(probably empty in your case).
---
Something that I want to say but should not end up in the changelog.

Patch.

Seeing that you have probably generated your patch from git, git
format-patch and git send-email are useful commands for submitting patches
via email.

								Honza
