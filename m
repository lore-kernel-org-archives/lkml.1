Return-Path: <linux-kernel-owner+w=401wt.eu-S933528AbYD2TCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528AbYD2TCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932992AbYD2TBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:01:01 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58435 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932957AbYD2TA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:00:59 -0400
Date: Tue, 29 Apr 2008 21:01:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       ajackson@redhat.com, airlied@redhat.com, benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] make access_process_vm work on device memory
Message-ID: <20080429190132.GA25793@uranus.ravnborg.org>
References: <20080429113237.614f89a1@cuia.boston.redhat.com> <20080429110919.dc7b8565.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429110919.dc7b8565.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> urgh.
> 
> We have HAVE_ARCH*
> We have __HAVE_ARCH*
> We have ARCH_HAS*
> We have __ARCH_HAS*
> 
> what a mess.
> 
> Probably the preferred (but still ugly) approach is to implement
> CONFIG_ARCH_*.
Only if it is a Kconfig symbol.

We have recently started to use 'HAVE_*' for boolean symbols used
to select a specific function for one architecture.
See arch/Kconfig for a few samples.

And Documentation/kbuild/kconfig-language.txt for usage hints.

	Sam
