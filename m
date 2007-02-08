Return-Path: <linux-kernel-owner+w=401wt.eu-S1423278AbXBHUEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423278AbXBHUEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423296AbXBHUEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:04:46 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:38584 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423278AbXBHUEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:04:45 -0500
Date: Thu, 8 Feb 2007 14:57:11 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] UML hang with 100% CPU
Message-ID: <20070208195711.GA6607@ccure.user-mode-linux.org>
References: <E1HFEIB-0000nJ-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HFEIB-0000nJ-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 07:46:47PM +0100, Miklos Szeredi wrote:
> It boots fine, then usually just after logging in and before starting
> the shell (but sometimes after the shell started) it gets into some
> loop.  Looking at the strace shows that two processes are
> sending/receiving single '\0' bytes on some sockets endlessly.
> 
> Does this ring a bell?

No, it doesn't.  This is a strace on the host, I take it?

Can you get backtraces from the processes?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
