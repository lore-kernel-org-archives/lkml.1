Return-Path: <linux-kernel-owner+w=401wt.eu-S1762868AbZD1QCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762868AbZD1QCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762771AbZD1QB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:01:56 -0400
Received: from kroah.org ([198.145.64.141]:39775 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762779AbZD1QBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:01:55 -0400
Date: Tue, 28 Apr 2009 08:58:52 -0700
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21] amd64_edac: EDAC module for AMD64
Message-ID: <20090428155852.GA9956@kroah.com>
References: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240931173-17477-1-git-send-email-borislav.petkov@amd.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 05:05:52PM +0200, Borislav Petkov wrote:
> Hi Andrew,
> hi Greg,
> 
> I think you've already heard about this driver, so here is a first
> upstream submission request. It is quite sizable but partly the reason
> for it is that it handles ECC detection and reporting for all AMD
> K8, F10h and F11h families. It also implements DRAM error injection
> functionality, failing DIMM module detection and some other fun stuff
> found on F10h and later CPUs.
> 
> We've been doing testing/bugfixing/scrubbing here for some time, have
> converted it to using kernel facilities and basically removed some slack
> from it like glue code due to it being maintained out-of-tree. Please
> take a look and let us know of any objections/comments you might have so
> that we could tackle them on time.

At first glance, it looks sane to me.

Want me to put it in my driver tree so it can show up in -next?  Or is
there some other tree you want to use?

thanks,

greg k-h
