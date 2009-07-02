Return-Path: <linux-kernel-owner+w=401wt.eu-S1754843AbZGBXKH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbZGBXKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:10:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZGBXJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:09:57 -0400
Received: from 174-143-236-118.static.slicehost.net ([174.143.236.118]:52048
	"EHLO fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZGBXJ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:09:56 -0400
Date: Thu, 2 Jul 2009 19:09:55 -0400
To: David Howells <dhowells@redhat.com>
Cc: steved@redhat.com, rasmus@msconsult.dk, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFSD: Don't hold unrefcounted creds over call to
	nfsd_setuser()
Message-ID: <20090702230955.GB12376@fieldses.org>
References: <20090702203937.GA10504@fieldses.org> <20090702133532.28297.89635.stgit@warthog.procyon.org.uk> <575.1246570293@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <575.1246570293@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 10:31:33PM +0100, David Howells wrote:
> J. Bruce Fields <bfields@fieldses.org> wrote:
> 
> > Got it, thanks.  How easy is it to hit this case?  (Just wondering
> > whether to submit for stable.)
> 
> Actually, one of the problems with it is that the file is opened using the old
> creds, cached across the call to nfsd_setuser().

Oops, got it.  That answers that question....

--b.
