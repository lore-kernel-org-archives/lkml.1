Return-Path: <linux-kernel-owner+w=401wt.eu-S1031073AbXFHSrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031073AbXFHSrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937496AbXFHSrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:47:36 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49799 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936025AbXFHSrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:47:35 -0400
Date: Fri, 8 Jun 2007 19:46:51 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
Message-ID: <20070608184650.GA4095@ftp.linux.org.uk>
References: <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com> <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com> <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com> <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu> <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com> <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4669A351.4010403@redhat.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 11:43:29AM -0700, Ulrich Drepper wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Alan Cox wrote:
> > Why does he want an unpredictable algorithm
> 
> To avoid exactly the kind of problem we have now in future: programs
> relying on specific patterns.

You are making debugging no end of fun...
