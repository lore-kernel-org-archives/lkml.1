Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbYBTGoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbYBTGoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:44:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbYBTGn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:43:56 -0500
Received: from lazybastard.de ([212.112.238.170]:36180 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbYBTGnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:43:55 -0500
Date: Wed, 20 Feb 2008 07:43:22 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
       Stephane Chazelas <stephane.chazelas@emerson.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Message-ID: <20080220064321.GB29587@lazybastard.org>
References: <chaz20080212134751.GI30304@artesyncp.com> <chaz20080212161034.GJ30304@artesyncp.com> <20080219150822.GA29587@lazybastard.org> <200802192333.39707.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802192333.39707.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 February 2008 23:33:38 +0100, Arnd Bergmann wrote:
> 
> Given that loop works in this way, I certainly see that as doable,
> but then I'd vote for using the existing ioctl semantics of
> LOOP_SET_FD and LOOP_DEL_FD on the mtdchar device, which already
> comes with an ioctl interface for mtd devices.
> I'd probably also allow the LOOP_{GET,SET}_STATUS{,64} commands,
> so you can actually use the existing losetup tool.
> That way, we wouldn't have to introduce a new API, just extend
> an existing one to work on more things.

I like this approach.  It somewhat collides with the mtd principle of
having a seperate module for every 2-3 lines of code, but maybe that is
not a bad thing after all.

Onto my list of code to write on rainy afternoons (and secretly hoping
for others to do it instead).

Jörn

-- 
Mundie uses a textbook tactic of manipulation: start with some
reasonable talk, and lead the audience to an unreasonable conclusion.
-- Bruce Perens
