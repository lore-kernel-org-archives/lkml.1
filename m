Return-Path: <linux-kernel-owner+w=401wt.eu-S1762752AbZBYPi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762752AbZBYPi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbZBYPiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:38:16 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:34147 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbZBYPiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:38:15 -0500
Date: Wed, 25 Feb 2009 08:37:57 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Justin Chen <jchen@hpdst41.cup.hp.com>, linux-arch@vger.kernel.org,
       bjorn.helgaas@hp.com, justin.chen@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] bitops: Change bitmap index from int to unsigned long
Message-ID: <20090225153757.GP16891@parisc-linux.org>
References: <200902250441.UAA12527@hpdst41.cup.hp.com> <1235544888.4645.2942.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235544888.4645.2942.camel@laptop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 07:54:48AM +0100, Peter Zijlstra wrote:
> unsigned int wasn't large enough?

Adding one more bit only doubles the maximum size.  That buys us, what,
another eighteen months until we have to change it again?  Unsigned long
seems most sensible to me.  Unsigned long long probably isn't worth
doing -- you'd have to be using one eighth of your address space on a
single bitmap.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
