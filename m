Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbXJOES1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbXJOES1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 00:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXJOEST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 00:18:19 -0400
Received: from gw.goop.org ([64.81.55.164]:50834 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbXJOESS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 00:18:18 -0400
Message-ID: <4712EA09.6000102@goop.org>
Date: Sun, 14 Oct 2007 21:18:17 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, xfs@oss.sgi.com,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       =?ISO-8859-1?Q?Morten_B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
References: <470FA7C3.90404@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <4712BB05.1020701@goop.org> <200710151726.08387.nickpiggin@yahoo.com.au> <4712E1AA.501@goop.org> <20071015041133.GH995458@sgi.com>
In-Reply-To: <20071015041133.GH995458@sgi.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> With defaults - little effect as vmap should never be used. It's
> only when you start using larger block sizes for metadata that this
> becomes an issue. The CONFIG_XEN workaround should be fine until we
> get a proper vmap cache....

Hm, well I saw the problem with a filesystem made with mkfs.xfs with no
options, so there must be at least *some* vmapping going on there.

    J
