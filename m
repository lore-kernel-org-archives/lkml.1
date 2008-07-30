Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYG3Umc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYG3Umc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751162AbYG3UmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:42:23 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:19035 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbYG3UmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:42:23 -0400
Date: Wed, 30 Jul 2008 22:43:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [genksyms patch 1/4] parser: fix the __attribute__ rule
Message-ID: <20080730204311.GA17287@uranus.ravnborg.org>
References: <20080721022823.896799736@suse.de> <20080721025912.739333284@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080721025912.739333284@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 04:28:24AM +0200, Andreas Gruenbacher wrote:
> Gcc __attribute__ definitions may occur repeatedly, e.g.,
> 
> 	static int foo __attribute__((__used__))
> 		       __attribute__((aligned (16)));
> 
> The genksyms parser does not understand this, and generates a syntax error.
> Fix this case.
> 
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Can I ask you to update the _shipped files and resend the patch.
I have only bison 2.1 available on my box and
I do not want to downgrade when regenerating the bison files.

To do it just do a:
make clean
make allmodconfig
make GENERATE_PARSER=1 modules

Drop the other _shipped files that are not relevant
(keywords.c and lex.c).

	Sam
