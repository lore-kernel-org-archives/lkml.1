Return-Path: <linux-kernel-owner+w=401wt.eu-S1765610AbYD3UfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765610AbYD3UfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760693AbYD3Ue7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:34:59 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55145 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760899AbYD3Ue6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:34:58 -0400
Date: Wed, 30 Apr 2008 21:27:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext3: Fix typos in messages and comments (journalled ->
 journaled)
Message-ID: <20080430212711.168bdcc0@core>
In-Reply-To: <20080430104330.66c44d4f.akpm@linux-foundation.org>
References: <12095679813226-git-send-email-jack@suse.cz>
	<12095679812375-git-send-email-jack@suse.cz>
	<12095679812452-git-send-email-jack@suse.cz>
	<1209567981639-git-send-email-jack@suse.cz>
	<20080430104330.66c44d4f.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 10:43:30 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 30 Apr 2008 17:06:15 +0200
> Jan Kara <jack@suse.cz> wrote:
> 
> > -					"EXT3-fs: Cannot change journalled "
> > +					"EXT3-fs: Cannot change journaled "
> 
> hrm, who said?

This has come up several times before so I thought it might be time to
finally dig to the bottom of the pile and end it forever.

I put on my library hat and went for a dig: the verb is in fact "to
journalize", which according to the OED means

"enter (notes or information) in a journal"

Journal itself is strictly a noun. Thus in English it would be correct
for a file system to have a journal (from the latin diurnalis if anyone
cares) but it would appear that it is a journalizing file system.

The American dictionaries appear to agree with this viewpoint.

If we regard "journalizing" as incorrect then the natural way to end the
word would be -lled for British English and -led would certainly sound
and feel wrong. Indeed the search for the OED turns journalled into
journal when guessing near words but refuses to consider journaled. Our
existing policy is not to mess with US v UK v AU v CA v .. spelling
and that is probably wise. 

A search of the ACM literature finds "journalized", "journalled" and
"journaled" are all in use for this operation.

I would submit the correct patch is to change the words to journalizing
and journalized. That would put Linux in agreement with the dictionary,
avoid US v UK meaning differences and not pose a problem linguistically
as all forms are currently in use.

Alan
