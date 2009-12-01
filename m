Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZLAUa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZLAUa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZLAUaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:30:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZLAUaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:30:24 -0500
Subject: Re: [PATCH] perf tools: allow cross compiling of perf tools
From: Peter Zijlstra <peterz@infradead.org>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       "Michael S. Tsirkin" <mst@redhat.com>
In-Reply-To: <1259699050.4003.15.camel@laptop>
References: <1259698310-11025-1-git-send-email-jamie@jamieiles.com>
	 <1259699050.4003.15.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 21:30:28 +0100
Message-ID: <1259699428.4003.23.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 21:24 +0100, Peter Zijlstra wrote:
> On Tue, 2009-12-01 at 20:11 +0000, Jamie Iles wrote:
> > For embedded systems we need to cross compile applications on
> > the build machine. Use the CROSS_COMPILE variable like the kernel
> > itself.
> > 
> > Additionally, we can't use uname to determine whether we should
> > build for 64 bit. Use the -dumpmachine flag of GCC to determine
> > the target arch.
> 
> Hmm, and here I though Michael already send something similar to this..
> but apparently I can't really find it

Ah, I'm turning senile, was looking at the wrong kernel tree.

Your patch is against something ancient too ;-)

