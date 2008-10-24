Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbYJXK3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbYJXK3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 06:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYJXK3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 06:29:08 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:36308 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYJXK3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 06:29:07 -0400
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH 0/8] scheduler patches
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, efault@gmx.de, vatsa@in.ibm.com
In-Reply-To: <20081024102655.GA1738@elte.hu>
References: <20081024090611.936552213@chello.nl>
	 <20081024102655.GA1738@elte.hu>
Content-Type: text/plain
Date: Fri, 24 Oct 2008 12:29:11 +0200
Message-Id: <1224844151.27946.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 12:26 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > 6-8 29 work
> 
> Could we have a #9 that uses a no-fastpath-overhead min() method instead 
> of avg_vruntime? Maybe we can get away without that overhead?

Looking at that suggestion, maybe I'll redo 7/8 so at to not depend on
6/8 using min from the get-go and fixing that XXX as well.

Will have to poke at it a little.

