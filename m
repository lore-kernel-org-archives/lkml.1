Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbXEAWYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbXEAWYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbXEAWYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:24:45 -0400
Received: from waste.org ([66.93.16.53]:41771 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbXEAWYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:24:45 -0400
Date: Tue, 1 May 2007 17:24:32 -0500
From: Matt Mackall <mpm@selenic.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix dynticks for voyager
Message-ID: <20070501222432.GP11166@waste.org>
References: <1177951131.3674.37.camel@mulgrave.il.steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1177951131.3674.37.camel@mulgrave.il.steeleye.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 11:38:51AM -0500, James Bottomley wrote:
> As usual voyager tripped over an explicit boot CPU is zero assumption in
> the dynticks code.  This is the fix I have queued in the voyager tree.

Can we flush out all these assumptions by adding a constant offset
somewhere? Or reversing the ordering?

-- 
Mathematics is the supreme nostalgia of our time.
