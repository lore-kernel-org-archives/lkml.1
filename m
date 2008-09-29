Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbYI2Upg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbYI2Upg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 16:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYI2Up2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 16:45:28 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59041 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbYI2Up2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 16:45:28 -0400
Date: Mon, 29 Sep 2008 22:50:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pardo <pardo@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, dean gaudet <odo@google.com>,
       linux-kernel@vger.kernel.org, mbligh@google.com, briangrant@google.com,
       nil@google.com, jyasskin@google.com
Subject: Re: Faster getcpu() and sched_getcpu()
Message-ID: <20080929205054.GR25711@one.firstfloor.org>
References: <af8810200809111648n55e05ac9g286fcd498690432f@mail.gmail.com> <af8810200809231209w7428347neb88094e543a048f@mail.gmail.com> <87wsgwp6gh.fsf@basil.nowhere.org> <48E0834D.6010608@google.com> <20080929145408.GQ25711@one.firstfloor.org> <af8810200809291101r6f3208beua36a4b2d3b5713eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af8810200809291101r6f3208beua36a4b2d3b5713eb@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 11:01:26AM -0700, Pardo wrote:
> >[Maybe disable frame pointers for vsyscall.c and the vdso?]
> 
> IIRC, some vsyscall.c code needs them enabled, so Dean's earlier patch split

I don't think it really needs it.

> vsyscall.c, creating a vsyscall_user.c for code which can run without them.
> Seem reasonable?

Seems unnecessarily complicated.

-Andi

-- 
ak@linux.intel.com
