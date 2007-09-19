Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbXISBff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbXISBff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 21:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbXISBf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 21:35:28 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:49049 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXISBf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 21:35:27 -0400
Date: Tue, 18 Sep 2007 21:35:12 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Philipp Marek <philipp@marek.priv.at>, linux-kernel@vger.kernel.org
Subject: Re: UML dead with current -git?
Message-ID: <20070919013512.GA10873@c2.user-mode-linux.org>
References: <200709181714.34035@x5> <20070918171313.GA6591@c2.user-mode-linux.org> <20070918175513.GD26539@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918175513.GD26539@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 07:55:13PM +0200, Sam Ravnborg wrote:
> Sounds to me like a known issue by you. Can you give a few more details
> so we maybe can get it fixed?

I believe what happened here is an x86_64 build followed by a
UML/x86_64 build with no intervening mrproper.

I've always considered this to be a "don't do that" sort of thing.
However, maybe we could stick the arch of the current build somewhere
in the tree, check that before any serious part of a subsequent
build, and error out if $ARCH is different.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
