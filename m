Return-Path: <linux-kernel-owner+w=401wt.eu-S1762815AbYEEVrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762815AbYEEVrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 17:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762596AbYEEVqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 17:46:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57419 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762453AbYEEVqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 17:46:50 -0400
Date: Mon, 5 May 2008 14:46:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       sam@ravnborg.org, viro@ftp.linux.org.uk, hpa@zytor.com,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [rfc] the kernel workflow & trivial "global -> static" patches
 (was: Re: [2.6 patch] make sched_feat_{names,open} static)
Message-ID: <20080505144625.2abc8e63@infradead.org>
In-Reply-To: <20080505142604.389f05c6.akpm@linux-foundation.org>
References: <20080505182942.GA17139@cs181133002.pp.htv.fi>
	<20080505201906.GA900@elte.hu>
	<20080505134252.c82a64f6.akpm@linux-foundation.org>
	<20080505210712.GD1544@cs181133002.pp.htv.fi>
	<20080505142604.389f05c6.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008 14:26:04 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> Actually, we could perhaps do a lot of this at the checkpatch level?
> If checkpatch sees a global symbol being added and the same patch
> does not add references to that symbol from a different file then
> whine.  Obviously this will generate false positives but that's OK.

or.. doesn't add it to a header file. That might be even more generic;
(and enforces a "all global functions need a prototype in a header
somewhere)
