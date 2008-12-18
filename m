Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753279AbYLRKrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbYLRKrE (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:47:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbYLRKqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:46:06 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:34874 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbYLRKqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:46:05 -0500
Subject: Re: [PATCH 03/15] kmemleak: Add the slab memory allocation/freeing
	hooks
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, cl@linux-foundation.org
In-Reply-To: <1229092065.15045.35.camel@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182710.30323.57396.stgit@pc1117.cambridge.arm.com>
	 <494184AA.8090509@cs.helsinki.fi>
	 <1229092065.15045.35.camel@pc1117.cambridge.arm.com>
Date: Thu, 18 Dec 2008 12:46:02 +0200
Message-Id: <1229597162.1047.48.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 14:27 +0000, Catalin Marinas wrote:
> > Do you take care of the per-node lists as well?
> 
> I can't figure out what other location should be erased.

As far as I can tell, you need to tell kmemleak not to scan the alien
caches and the shared array that is shared by all CPUs that belong to
one node. I'm adding Christoph to the CC in case he wants to comment on
this.

