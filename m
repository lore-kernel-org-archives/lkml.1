Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbZI3Gzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbZI3Gzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 02:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZI3Gzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 02:55:35 -0400
Received: from [195.41.46.236] ([195.41.46.236]:53819 "EHLO pfepb.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752843AbZI3Gze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 02:55:34 -0400
Date: Wed, 30 Sep 2009 08:55:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC] move #define pr_fmt KBUILD_MODNAME and KMSG_COMPONENT to
	Makefiles?
Message-ID: <20090930065533.GB13850@merkur.ravnborg.org>
References: <1254248104.28232.447.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254248104.28232.447.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe.

On Tue, Sep 29, 2009 at 11:15:04AM -0700, Joe Perches wrote:
> There are starting to be more uses of
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> and
> 
> #define KMSG_COMPONENT "foo"
> #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> 
> in kernel sources.
> 
> Perhaps it would be better to put these
> defines in the appropriate Makefile and not
> sprinkle the sources with them multiple times?

Maybe I'm a bit dense but I do not quiete follow you
here. What is it you want moved to kbuild here?

To me it looks more like a logical extension to the
pr_* macros based on info we already have available.

	Sam
