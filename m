Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbZGBVbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbZGBVbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZGBVbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:31:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36594 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbZGBVbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:31:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090702203937.GA10504@fieldses.org>
References: <20090702203937.GA10504@fieldses.org> <20090702133532.28297.89635.stgit@warthog.procyon.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, steved@redhat.com, rasmus@msconsult.dk,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] NFSD: Don't hold unrefcounted creds over call to nfsd_setuser()
Date: Thu, 02 Jul 2009 22:31:33 +0100
Message-ID: <575.1246570293@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> Got it, thanks.  How easy is it to hit this case?  (Just wondering
> whether to submit for stable.)

Actually, one of the problems with it is that the file is opened using the old
creds, cached across the call to nfsd_setuser().

David
