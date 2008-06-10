Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYFJQ5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYFJQ5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 12:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYFJQ5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 12:57:24 -0400
Received: from [198.99.130.12] ([198.99.130.12]:35379 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYFJQ5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 12:57:23 -0400
Date: Tue, 10 Jun 2008 12:54:32 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linuxfoundation.org,
       linux-kernel@vger.kernel.org,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: 2.6.26-rc5-mm1: uml link error
Message-ID: <20080610165432.GA8339@c2.user-mode-linux.org>
References: <OF61F32674.CE1F9CB0-ONC1257464.004D17DC-C1257464.004DB50E@de.ibm.com> <484E8DD2.5050603@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <484E8DD2.5050603@de.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 04:21:06PM +0200, Peter Oberparleiter wrote:
> Subject: kernel: disable constructor calling for uml
> 
> From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> 
> Disable calling of constructor functions from within the kernel for uml
> as they are already called by the host run-time environment.

OK, maybe it is the right fix.  I didn't realize it was for gcov
support only.

It's still kinda ugly though.  If you stick with this, I'd put
comments on those ifdefs saying why UML is special.

	    	  	 Jeff

-- 
Work email - jdike at linux dot intel dot com
