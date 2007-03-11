Return-Path: <linux-kernel-owner+w=401wt.eu-S1751611AbXCKBHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbXCKBHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 20:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbXCKBHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 20:07:51 -0500
Received: from waste.org ([66.93.16.53]:33408 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbXCKBHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 20:07:50 -0500
Date: Sat, 10 Mar 2007 18:55:07 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@outflux.net>, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: maps protection
Message-ID: <20070311005507.GC10459@waste.org>
References: <20070306175609.267bd7a9.akpm@linux-foundation.org> <20070307021335.GR9621@outflux.net> <20070306185942.585e7cd1.akpm@linux-foundation.org> <20070307031429.GU9621@outflux.net> <1173241331.3236.10.camel@laptopd505.fenrus.org> <20070308205525.GJ6805@outflux.net> <20070309183006.7ff23eff.akpm@linux-foundation.org> <45F23BB5.8090907@linux.intel.com> <20070310183341.GB10460@outflux.net> <20070310162101.716b6b57.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070310162101.716b6b57.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2007 at 04:21:01PM -0800, Andrew Morton wrote:
> > On Sat, 10 Mar 2007 10:33:41 -0800 Kees Cook <kees@outflux.net> wrote:
> > Here's another revision, with both the "can ptrace" and the global /proc 
> > knob;
> 
> We'd be needing a changelog for that.
> 
> Please update the procfs documentation.
> 
> Does the patch also cover /proc/pid/smaps?

Also, we ought to revisit /proc/pid/mem write, which is currently disabled.
Either drop the code, fix it, or make it root only.

-- 
Mathematics is the supreme nostalgia of our time.
