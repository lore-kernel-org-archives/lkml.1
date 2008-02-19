Return-Path: <linux-kernel-owner+w=401wt.eu-S1763231AbYBSJn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763231AbYBSJn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 04:43:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYBSJnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 04:43:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44471 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759204AbYBSJnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 04:43:46 -0500
Date: Tue, 19 Feb 2008 10:43:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Chinner <dgc@sgi.com>, Michael Tokarev <mjt@tls.msk.ru>,
       Ric Wheeler <ric@emc.com>,
       device-mapper development <dm-devel@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080219094348.GE6485@one.firstfloor.org>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com> <47B9870B.8060005@msgid.tls.msk.ru> <20080218221644.GN155407@sgi.com> <20080219025643.GD4066@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219025643.GD4066@agk.fab.redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My complaint about having to support them within dm when more than one
> device is involved is because any efficiencies disappear: you can't send
> further I/O to any one device until all the other devices have completed
> their barrier (or else later I/O to that device could overtake the
> barrier on another device).  And then I argue that it would be better

I was wondering: would it help DM to have the concept of a "barrier window"
As in "this barrier is only affective for this group of requests"
With such a concept DM would need to stall only inside the groups
and possible even issue such barrier groups in parallel, couldn't it?

I'm sure you guys all have thought far more about barriers than
I ever did; if that idea came up before why was it dismissed?

-Andi

