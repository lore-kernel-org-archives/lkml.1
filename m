Return-Path: <linux-kernel-owner+w=401wt.eu-S1753455AbXJWOdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455AbXJWOdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbXJWOde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:33:34 -0400
Received: from gw.goop.org ([64.81.55.164]:51906 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbXJWOde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:33:34 -0400
Message-ID: <471E063C.4020204@goop.org>
Date: Tue, 23 Oct 2007 07:33:32 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: Andi Kleen <andi@firstfloor.org>, dean gaudet <dean@arctic.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: [patch] Re: Interaction between Xen and XFS: stray RW mappings
References: <alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org> <471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de> <471CEEB4.9040807@goop.org> <20071022190740.GA1695@one.firstfloor.org> <20071022223224.GC995458@sgi.com> <20071022233514.GA9057@one.firstfloor.org> <20071023003641.GF995458@sgi.com> <20071023070414.GM66820511@sgi.com> <20071023093035.GB24536@one.firstfloor.org> <20071023124137.GP66820511@sgi.com>
In-Reply-To: <20071023124137.GP66820511@sgi.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner wrote:
> Nick, Jeremy, (others?) any objections to this approach to solve
> the problem?

Seems sounds in principle.   I think Nick's shootdown-stray-mappings mm
API call is a better long-term answer, but this will do for now.  I'll
test it out today.

    J
