Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268AbYFRQwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbYFRQwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 12:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYFRQwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 12:52:06 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:44600 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYFRQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 12:52:04 -0400
Date: Wed, 18 Jun 2008 12:51:38 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kbuild breaks um - fails to find util when linking
Message-ID: <20080618165138.GD8225@c2.user-mode-linux.org>
References: <20080610190307.GA15983@uranus.ravnborg.org> <20080611154816.GA8167@c2.user-mode-linux.org> <20080612180859.GA2271@uranus.ravnborg.org> <20080612201315.GA10879@c2.user-mode-linux.org> <20080612210615.GA7558@uranus.ravnborg.org> <4852FDFC.1020403@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4852FDFC.1020403@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 01:08:44AM +0200, Gabriel C wrote:
> Another thing I noticed is this hunk :
> 
> +$(shell $(CC) -print-file-name=ld-linux.so.2) \
> 
> On 64bit that should not work since it is ld-linux-x86-64.so.2 and not ld-linux.so.2

That's a good point too.

This seems like an awful lot of fragile hair to go through in order to
avoid using gcc to drive the link.

      	    	   	 Jeff

-- 
Work email - jdike at linux dot intel dot com
