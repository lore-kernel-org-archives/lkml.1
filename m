Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbXFSUjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbXFSUjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753913AbXFSUis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:38:48 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44276 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbXFSUip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:38:45 -0400
Date: Tue, 19 Jun 2007 14:38:43 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: John Stoffel <john@stoffel.org>
Cc: Jack Stone <jack@hawkeye.stone.uk.eu.org>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>, alan <alan@clueserver.org>
Subject: Re: Versioning file system
Message-ID: <20070619203843.GU8154@parisc-linux.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com> <4678292B.6000804@hawkeye.stone.uk.eu.org> <4678369C.7070908@redhat.com> <467837AB.4030607@hawkeye.stone.uk.eu.org> <18040.15842.698982.608861@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18040.15842.698982.608861@stoffel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 04:34:42PM -0400, John Stoffel wrote:
> >>>>> "Jack" == Jack Stone <jack@hawkeye.stone.uk.eu.org> writes:
> 
> Jack> The whole idea of the file system is that it wouldn't return the
> Jack> file in the file listing. The user would have to know that the
> Jack> file system was versioning to access the older versions as they
> Jack> would explicitly have to request them.
> 
> So tell me what happens when I do:
> 
> 	touch foo:121212121212

You create a new file called 'foo:121212121212'.  If you then modify it,
you could access the old version as foo:121212121212:0.

(The .snapshot directory makes more sense than magic names, since you
can see what versions of a file are available without a special tool).
