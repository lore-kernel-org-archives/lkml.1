Return-Path: <linux-kernel-owner+w=401wt.eu-S1031408AbXFHTI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031408AbXFHTI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031051AbXFHTIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:08:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33101 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753597AbXFHTIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:08:47 -0400
Date: Fri, 8 Jun 2007 12:07:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: Al Viro <viro@ftp.linux.org.uk>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <4669A674.4080309@redhat.com>
Message-ID: <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org>
References: <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu>
 <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
 <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com>
 <20070608184650.GA4095@ftp.linux.org.uk> <4669A674.4080309@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Jun 2007, Ulrich Drepper wrote:
> 
> We are talking about file descriptors here.  If you're using file
> descriptors as anything other than tokens you'll find out soon enough
> that your code is broken.  The new type of file descriptors cannot be
> used as indeces and the randomization makes sure that no program by some
> fluke happens to work.

No, Uli.

You need things to be *repeatable* for debugging. No ifs, buts, or maybes 
about it.

I think truly random is a bad idea, or at the very least needs some way to 
disable it.

		Linus
