Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbXJHPsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbXJHPsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 11:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751575AbXJHPsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 11:48:47 -0400
Received: from [198.99.130.12] ([198.99.130.12]:36917 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbXJHPsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:48:46 -0400
Date: Mon, 8 Oct 2007 11:47:53 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Magotari@gail.com
Subject: Re: [uml-devel] [PATCH 1/3] UML - Fix stub address calculations
Message-ID: <20071008154753.GA6495@c2.user-mode-linux.org>
References: <20071001212306.GA10113@c2.user-mode-linux.org> <Pine.LNX.4.64.0710020841411.28398@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710020841411.28398@anakin>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2007 at 08:43:00AM +0200, Geert Uytterhoeven wrote:
> Hmm, perhaps you can use _AC() (from <linux/const.h>) to defined the original
> constants instead, so you don't need the #ifdefs?

Ah, neat.  Those are exactly what I need.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
