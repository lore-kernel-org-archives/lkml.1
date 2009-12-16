Return-Path: <linux-kernel-owner+w=401wt.eu-S1762197AbZLPPEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762197AbZLPPEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759290AbZLPPEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:04:44 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41092 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969AbZLPPEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:04:43 -0500
Date: Wed, 16 Dec 2009 10:04:42 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Kyle McMartin <kyle@mcmartin.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: anyone including <linux/perf_counter.h>?
Message-ID: <20091216150442.GN28962@bombadil.infradead.org>
References: <alpine.LFD.2.00.0912160939510.7588@localhost> <20091216145120.GL28962@bombadil.infradead.org> <alpine.LFD.2.00.0912160955420.7853@localhost> <20091216145851.GM28962@bombadil.infradead.org> <alpine.LFD.2.00.0912161000130.7970@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912161000130.7970@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 10:01:39AM -0500, Robert P. J. Day wrote:
> 
>   1) add it into Kbuild, since user-space needs it, or
> 
>   2) delete it entirely since it's never been in user-space all
>      this time but no one seems to have missed it.  :-)
> 

My guess is the latter, since it was never exported. I just noticed that
Chuck added it to Kbuild after the rename, so it has never been exported
at all with the previous interface.
