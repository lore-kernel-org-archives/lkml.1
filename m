Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbXJVSdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbXJVSdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbXJVSc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:32:58 -0400
Received: from gw.goop.org ([64.81.55.164]:49695 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbXJVSc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:32:58 -0400
Message-ID: <471CECD9.3010409@goop.org>
Date: Mon, 22 Oct 2007 11:32:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: dean gaudet <dean@arctic.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       =?ISO-8859-1?Q?Morten_?= =?ISO-8859-1?Q?B=F8geskov?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com> <4712A254.4090604@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <alpine.DEB.0.9999.0710212128180.2320@twinlark.arctic.org>
In-Reply-To: <alpine.DEB.0.9999.0710212128180.2320@twinlark.arctic.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

dean gaudet wrote:
> sounds like a bug in xen to me :)
>   

I explained at the head of this thread how and why Xen works in this
manner.  It's certainly a change from native execution; whether you
consider it to be a bug is a different matter.

But it turns out that leaving stray mappings around on pages which get
later used in special ways is a bad idea, and can manifest in all kinds
of random unpleasant ways.  Getting a clear error out of Xen is probably
nicest way to discover and debug this problem.

    J
