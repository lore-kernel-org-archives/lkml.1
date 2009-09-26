Return-Path: <linux-kernel-owner+w=401wt.eu-S1752431AbZIZTOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431AbZIZTOw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 15:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbZIZTOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 15:14:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZIZTOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 15:14:51 -0400
Date: Sat, 26 Sep 2009 21:14:54 +0200
From: Nick Piggin <npiggin@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] HWPOISON: remove the unsafe __set_page_locked()
Message-ID: <20090926191454.GD14368@wotan.suse.de>
References: <20090926031537.GA10176@localhost> <Pine.LNX.4.64.0909261115530.12927@sister.anvils> <20090926114806.GA12419@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926114806.GA12419@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 07:48:06PM +0800, Wu Fengguang wrote:
> On Sat, Sep 26, 2009 at 07:09:21PM +0800, Hugh Dickins wrote:
> > It seems to me that the Intel hardware guys have done half a job
> > here: the sooner they get to remapping the bad pages, the better.
> 
> When we can offer to set aside half memory :)

Maybe even adding to the ECC error codes so uncorrected errors
are reduced to a similar frequency to other sources of errors in
the hardware. That seems like the sanest thing to me, but it's
not mine to wonder...

