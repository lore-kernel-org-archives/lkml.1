Return-Path: <linux-kernel-owner+w=401wt.eu-S1754621AbYCXFXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbYCXFXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 01:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYCXFXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 01:23:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58359 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYCXFXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 01:23:21 -0400
Date: Mon, 24 Mar 2008 06:26:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Ulrich Drepper <drepper@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Message-ID: <20080324052623.GA13691@one.firstfloor.org>
References: <a36005b50803191545h33d1a443y57d09176f8324186@mail.gmail.com> <20080320090005.GA25734@one.firstfloor.org> <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com> <20080321172644.GG2346@one.firstfloor.org> <a36005b50803212136s78dc2e4bx5ac715ebc7a6e48a@mail.gmail.com> <20080322071755.GP2346@one.firstfloor.org> <1206170695.2438.39.camel@entropy> <20080322091001.GA7264@one.firstfloor.org> <a36005b50803232120j63fb08d8p4a6cfdc8df2a3f21@mail.gmail.com> <1206335761.2438.63.camel@entropy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206335761.2438.63.camel@entropy>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


First emacs is still a rather small executable, there are much larger
ones around.

> The limit is filesystem dependent -- I think ext2/3s is something like
> 4k total for attribute names and values per inode.

That large xattrs tend to be out of line on a separate block and that would cost 
an additional seek. It would be unlikely to be continuous to the rest of the file 
data and thus even be worse than the SHDR which is at least likely to be
served from the same track buffer as the executable.

-Andi
