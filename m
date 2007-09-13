Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbXIMJc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbXIMJc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbXIMJct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:32:49 -0400
Received: from ns1.suse.de ([195.135.220.2]:48827 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbXIMJcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:32:48 -0400
To: venkatesh.pallipadi@intel.com
Cc: ashok.raj@intel.com, akinobu.mita@gmail.com, torvalds@osdl.org,
       patches@x86-64.org, linux-kernel@vger.kernel.org, jbeulich@novell.com
Subject: Re: [PATCH for 2.6.23] [2/3] x86_64: Prevent doing anything from cache_remove_dev() when info setup failed.
References: <20070911202.911586000@suse.de>
	<20070911120211.1E25F14EEC@wotan.suse.de>
From: Andi Kleen <andi@firstfloor.org>
Date: 13 Sep 2007 11:32:46 +0200
In-Reply-To: <20070911120211.1E25F14EEC@wotan.suse.de>
Message-ID: <p73myvqykox.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <ak@suse.de> writes:

> AK: Removed the unlikelies because gcc heuristics default to unlikely for tes
> AK: == NULL and for negative returns.

This patch was actually from Jan Beulich, but somehow the attribution
got dropped. Sorry for that.

-Andi
