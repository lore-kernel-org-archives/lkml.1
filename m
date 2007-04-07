Return-Path: <linux-kernel-owner+w=401wt.eu-S964773AbXDGAlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964773AbXDGAlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 20:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964791AbXDGAlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 20:41:09 -0400
Received: from gw.goop.org ([64.81.55.164]:52988 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964773AbXDGAlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 20:41:08 -0400
Message-ID: <4616E86D.30904@goop.org>
Date: Fri, 06 Apr 2007 17:40:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>,
       Zachary Amsden <zach@vmware.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 07/20] Allow paravirt backend to choose kernel PMD sharing
References: <20070404191151.009821039@goop.org>	<20070404191205.392155702@goop.org>	<20070406164139.08cd343b.akpm@linux-foundation.org>	<4616DFB2.4020802@goop.org> <20070406172844.12f7b8e7.akpm@linux-foundation.org>
In-Reply-To: <20070406172844.12f7b8e7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Something like that.  I don't want to redo my patch if we're going to change
> your patch ;)
>   

OK.  I won't specifically redo it on top of your patches, but I'll
rework it to remove the inline function and add the if() statement.  Do
you want an incremental update or a complete replacement?

    J
