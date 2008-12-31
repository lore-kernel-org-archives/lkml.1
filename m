Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbYLaVnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbYLaVnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 16:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbYLaVnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 16:43:10 -0500
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:27386 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbYLaVnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 16:43:09 -0500
Date: Wed, 31 Dec 2008 22:43:06 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Andrey Vul <andrey.vul@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28: BUG in r8169
In-Reply-To: <e38d12ff0812311037i14efe091m8550080678d0e2@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.0812312200130.11912@swampdragon.chaosbits.net>
References: <e38d12ff0812311037i14efe091m8550080678d0e2@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008, Andrey Vul wrote:

> trigger: wget 192.168.1.42/jdk-6-sdk-docs.zip
> eth0 speed grinds to zero in a few seconds
> IIRC r8169 worked fine in 2.6.27.8
> Anybody want to assist me with my first git bisect?
> 
There is lots of documentation, tutorials and howto documents etc on git 
bisect online.

Here are a few:
 http://www.kernel.org/pub/software/scm/git/docs/git-bisect.html
 http://www.reactivated.net/weblog/archives/2006/01/using-git-bisect-to-find-buggy-kernel-patches/
 http://kerneltrap.org/node/11753
 http://jbowes.dangerouslyinc.com/2007/02/18/git-bisect-a-practical-example-with-yum/
 http://desprofundis.blogspot.com/2008/06/git-bisect-instructions.html
 http://elinux.org/Notes_On_Git_Bisect#bisect

Mostly it's as simple as
 install git
 clone (usually) Linus' tree
 $ git bisect start
 $ git bisect bad v[bad-version]
 $ git bisect goot v[good-version]
 git now checks out a version to test, copy in your config, run make 
oldconfig, copile, test, then run
 $ git bisect [good|bad]
 depending on the result of the test and repeat with the next version git 
spits out until git tells you what the bad commit is.


-- 
Jesper Juhl <jj@chaosbits.net>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html

