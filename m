Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbYEGWSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbYEGWSv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764536AbYEGWSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:18:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52618 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762898AbYEGWSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:18:11 -0400
Date: Wed, 7 May 2008 15:17:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26, PAT and AMD family 6
Message-ID: <20080507151751.7a7484f1@infradead.org>
In-Reply-To: <4821FE2E.9030606@keyaccess.nl>
References: <48210A71.1060409@keyaccess.nl>
	<86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
	<4821A7E2.6080101@keyaccess.nl>
	<20080507064259.36deb978@infradead.org>
	<4821B801.5030508@keyaccess.nl>
	<20080507072431.30abefae@infradead.org>
	<4821FE2E.9030606@keyaccess.nl>
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

On Wed, 07 May 2008 21:08:30 +0200
> > 
> > we filter those for all kinds of things already, sorry.
> > What good is showing "pat" if "pat" isn't deemed usable (yet)????
> > Now *that* is deception :)
> 
> The trouble is -- if you hide that the CPU _should_ have PAT, how many
> people do you expect are going to look further and test? I knew that I
> should have PAT so I distrusted my CPU feature flag display but you've
> now limited your testers to people who've read the CPU datasheet.
> That's really no good.

and... why would we care? there's no upside even if you use pat.
pat is nice to avoid problems on newer systems that run out of mtrrs.
For older systems, right now, there isn't any.

 
> If Linux messes around with those flags already, it's doing things
> wrong already. /proc/cpuinfo is not a display of software features
> but of hardware features -- anything else is outright wrong. Being
> wrong for PAT also doesn't improve things.

that is your interpretation of what that file means.
It's... not so easy.
