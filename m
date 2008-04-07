Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYDGPkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYDGPkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYDGPjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:39:53 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:13318 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYDGPjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:39:52 -0400
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
From: Daniel Walker <dwalker@mvista.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <200804072256.IFJ17170.QFOJFHtLSOOVFM@I-love.SAKURA.ne.jp>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp>
	 <20080404122408.986477936@I-love.SAKURA.ne.jp>
	 <1207326576.21308.71.camel@localhost.localdomain>
	 <200804072256.IFJ17170.QFOJFHtLSOOVFM@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 08:39:49 -0700
Message-Id: <1207582789.21308.133.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-07 at 22:56 +0900, Tetsuo Handa wrote:
> Daniel Walker wrote:
> > From a reviews perspective what I would want is each set of changes,
> > file system, networking, arch, etc split into separate patches. For
> > example you have a number of patches just adding header files. You could
> > merge the header file with the hook additions. Then you have a natural
> > code split up which should be easier to review..
> Filesystem part to fsdevel, socket operation part to netdev. That's OK.
> But I wonder where to post the rest part.
> Since the patches for passing "struct vfsmount" to LSM has been rejected,
> TOMOYO has been unable to use LSM.
> Thus, I proposed this patch set as a non-LSM version, but it bothers me
> where to post this patch. If you know, please teach me where to post.

Not sure .. You might look through the MAINTAINERS file and see if
anyone maintains the sections of code your changing. Usually LKML and
Andrew are pretty good bets especially when your not sure who the
patches should go to.

Daniel

