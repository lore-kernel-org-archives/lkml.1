Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbZDJRDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbZDJRDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZDJRD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:03:29 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:58186 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZDJRD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:03:28 -0400
X-Greylist: delayed 938 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Apr 2009 13:03:28 EDT
From: hooanon05@yahoo.co.jp
Subject: Re: [RFC Aufs2 #5 28/29] export lookup functions 
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20090410165401.GA20673@infradead.org>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp> <1239346963-30953-29-git-send-email-hooanon05@yahoo.co.jp> <20090410162849.GA28377@infradead.org> <7612.1239382035@jrobl> <20090410165401.GA20673@infradead.org>
Date: Sat, 11 Apr 2009 02:03:14 +0900
Message-ID: <8041.1239382994@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph Hellwig:
> All these are vfs-internal bits, and there is no way we are going to
> export them.  aufs does a lot of really weird things like this because
> it's doing things in a filesystem that should be done in the VFS.

If I stop exporting lookup_hash() and replace it by vfs_path_lookup(),
will you review aufs patches again?


J. R. Okajima
