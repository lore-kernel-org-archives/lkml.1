Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZABOKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZABOKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZABOKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:10:25 -0500
Received: from thunk.org ([69.25.196.29]:37416 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914AbZABOKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:10:24 -0500
Date: Fri, 2 Jan 2009 09:10:14 -0500
From: Theodore Tso <tytso@mit.edu>
To: Andreas Sundstrom <sunkan@zappa.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
Message-ID: <20090102141014.GB4758@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andreas Sundstrom <sunkan@zappa.cx>, linux-kernel@vger.kernel.org
References: <20081226140721.GN9871@mit.edu> <4954FB62.4090306@zappa.cx> <20081226182145.GP9871@mit.edu> <495526F6.9040704@zappa.cx> <20081226193307.GA2138@mit.edu> <495553EB.6030604@zappa.cx> <20081227030632.GA3539@mit.edu> <4955F338.4020509@zappa.cx> <20090102031110.GF17821@mit.edu> <20090102092902.6p7echfdgkos40ss@zappa.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102092902.6p7echfdgkos40ss@zappa.cx>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 09:29:02AM +0100, Andreas Sundstrom wrote:
> 
> Well, the patch didn't work when I did "patch -i ext4.patch -p1" but I  
> did it manually and the code compiles and works fine.

The patch assumed some whitespace cleanups earlier in the ext4 patch
queue, which is probably why you had to apply the patch by hand.
Thanks for trying it out!!

May I add:

Tested-by: Andreas Sundstrom <sunkan@zappa.cx>

To the patch commit log?  We've been trying trying to give credit to
those people who work with kernel developers to test fixes, but given
that it does add peoples' e-mail addresses, it's something I always
ask permission to do if that person hasn't agreed to this sort of
thing already.

Thanks again,

						- Ted
