Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbXD0Riz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbXD0Riz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbXD0Riz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:38:55 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:53591 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092AbXD0Riy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:38:54 -0400
Date: Fri, 27 Apr 2007 13:35:11 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [patch] uml: fix cmpxchg warnings in -mm
Message-ID: <20070427173511.GA9373@c2.user-mode-linux.org>
References: <E1HhT90-0001dW-00@dorka.pomaz.szeredi.hu> <20070427172748.GC1046@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427172748.GC1046@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 07:27:48PM +0200, Sam Ravnborg wrote:
> Then atomic.h should include system.h and not rely on someone else doing it.
> Yes - then system.h may be included twice but that's ok.

I tried that - Andi didn't like it.  My current thinking is to pull the
cmpxchg stuff out of system.h into its own header since I don't see
any existing natural place to put it.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
