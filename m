Return-Path: <linux-kernel-owner+w=401wt.eu-S1751735AbXCEXQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbXCEXQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:16:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbXCEXQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:16:08 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:49771 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbXCEXQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:16:07 -0500
Date: Mon, 5 Mar 2007 18:07:11 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [PATCH 04/11] uml - hostfs: avoid possible escapes from hostfs=.
Message-ID: <20070305230711.GA9525@ccure.user-mode-linux.org>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan> <20070305204902.9072.1224.stgit@americanbeauty.home.lan> <20070305220334.GB7702@ccure.user-mode-linux.org> <200703052359.13612.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703052359.13612.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 11:59:13PM +0100, Blaisorblade wrote:
> I gave a look, and it's nice. Except that maybe "escapes_jail" would be a 
> clearer name (there's confusion about the subject of "escaping").

Feel free to change the name.

> Also, what about concurrent UML threads caring about current directory? I
> know that without SMP/preemption we can't have this problem, but
> when I see this I count a future bug unless this is checked (I think I
> reason mathematically about correctness, even if not formally).

Good point, yes this does need fixing for SMP.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
