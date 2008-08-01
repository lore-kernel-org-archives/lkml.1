Return-Path: <linux-kernel-owner+w=401wt.eu-S1755089AbYHANgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089AbYHANgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 09:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbYHANgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 09:36:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:40688 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYHANgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 09:36:08 -0400
Subject: Re: Need inforamtion on execve(2) on ENOMEM
From: Peter Zijlstra <peterz@infradead.org>
To: Halesh S <halesh.s@india.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <loom.20080801T132557-530@post.gmane.org>
References: <loom.20080801T132557-530@post.gmane.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 15:35:17 +0200
Message-Id: <1217597717.4684.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-01 at 13:30 +0000, Halesh S wrote:
> Hi,
> 
> I need a bit information regarding execve(2) sys call failure on no memory.
> 
> when execve(2) exits with ENOMEM, it will fail to return back to the calling 
> program as it receives the SIGKILL from the kernel.
> 
> Is it a right behavior that execve() will not return to calling 
> program on ENOMEM. As I understood execve(2) will not return only on success.
> 
> As errno will be lost, its very diffcult to judge execve(2) status.
> 
> If not expected behaviour,  I can provide a testcase for this.
> 
> Please let me about this.

It only does the SIGKILL bit when it runs out of memory after the old
programm is dead and the new programm isn't quite running yet.

So there is no calling programm to return to.

