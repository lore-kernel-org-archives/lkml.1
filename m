Return-Path: <linux-kernel-owner+w=401wt.eu-S1763359AbXHCP2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763359AbXHCP2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762554AbXHCP2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:28:36 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:47704 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762305AbXHCP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:28:35 -0400
Date: Fri, 3 Aug 2007 11:28:17 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: Re: UML: write errors on terminal
Message-ID: <20070803152817.GA7242@c2.user-mode-linux.org>
References: <E1IGvaz-0005Gq-00@dorka.pomaz.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IGvaz-0005Gq-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2007 at 01:45:29PM +0200, Miklos Szeredi wrote:
> I get errors in uml when writing to the xterm console.  For example if I do
> 
> $ cat bigfile
> [some output]
>   cat: write error: Operation not permitted
> 
> This is 2.6.23-rc1-mm2, I haven't yet checked other versions.

Rats, I fixed generic_read, but totally didn't look at generic_write.

A patch is forthcoming...

				Jeff

-- 
Work email - jdike at linux dot intel dot com
